import { useEffect, useState, type FormEvent } from 'react';
import { api } from '../lib/api';

interface DevotionForm {
  titleEn: string;
  titleKn: string;
  seriesEn: string;
  seriesKn: string;
  speaker: string;
  date: string;
  verseReferenceEn: string;
  verseReferenceKn: string;
  verseTextEn: string;
  verseTextKn: string;
  reflectionEn: string;
  reflectionKn: string;
  published: boolean;
}

const empty: DevotionForm = {
  titleEn: '',
  titleKn: '',
  seriesEn: '',
  seriesKn: '',
  speaker: '',
  date: '',
  verseReferenceEn: '',
  verseReferenceKn: '',
  verseTextEn: '',
  verseTextKn: '',
  reflectionEn: '',
  reflectionKn: '',
  published: true,
};

const MONTHS = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const currentYear = new Date().getFullYear();
const YEARS = Array.from({ length: 6 }, (_, i) => currentYear - 1 + i);

function daysInMonth(month: number, year: number): number {
  return new Date(year, month, 0).getDate();
}

function parseDevotionDate(dateStr: string): { day: number; month: number; year: number } {
  const fallback = new Date();
  if (!dateStr.trim()) {
    return {
      day: fallback.getDate(),
      month: fallback.getMonth() + 1,
      year: fallback.getFullYear(),
    };
  }
  const parsed = new Date(dateStr);
  if (!Number.isNaN(parsed.getTime())) {
    return {
      day: parsed.getDate(),
      month: parsed.getMonth() + 1,
      year: parsed.getFullYear(),
    };
  }
  return {
    day: fallback.getDate(),
    month: fallback.getMonth() + 1,
    year: fallback.getFullYear(),
  };
}

function formatDevotionDate(day: number, month: number, year: number): string {
  const safeDay = Math.min(day, daysInMonth(month, year));
  const date = new Date(year, month - 1, safeDay);
  return date.toLocaleDateString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });
}

export default function DevotionPage() {
  const [form, setForm] = useState<DevotionForm>(empty);
  const [dateDay, setDateDay] = useState(new Date().getDate());
  const [dateMonth, setDateMonth] = useState(new Date().getMonth() + 1);
  const [dateYear, setDateYear] = useState(new Date().getFullYear());
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    api.get('/admin/devotion')
      .then((data) => {
        setForm({ ...empty, ...data });
        const parts = parseDevotionDate(data.date ?? '');
        setDateDay(parts.day);
        setDateMonth(parts.month);
        setDateYear(parts.year);
      })
      .catch(() => {
        // Backend offline or empty — show blank form for demo
      });
  }, []);

  const maxDay = daysInMonth(dateMonth, dateYear);

  const setMonth = (month: number) => {
    setDateMonth(month);
    setDateDay((day) => Math.min(day, daysInMonth(month, dateYear)));
  };

  const setYear = (year: number) => {
    setDateYear(year);
    setDateDay((day) => Math.min(day, daysInMonth(dateMonth, year)));
  };

  const update = (key: keyof DevotionForm, value: string | boolean) => {
    setForm((f) => ({ ...f, [key]: value }));
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setMessage('');
    setError('');
    try {
      await api.put('/admin/devotion', {
        ...form,
        date: formatDevotionDate(dateDay, dateMonth, dateYear),
      });
      setMessage('Devotion saved. App will update within seconds.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Save failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <div>
      <h1>Daily Devotion</h1>
      {message && <div className="toast success">{message}</div>}
      {error && <div className="toast error">{error}</div>}
      <form className="card form-grid" onSubmit={handleSubmit}>
        <fieldset>
          <legend>English</legend>
          <label>Title<input value={form.titleEn} onChange={(e) => update('titleEn', e.target.value)} /></label>
          <label>Series<input value={form.seriesEn} onChange={(e) => update('seriesEn', e.target.value)} /></label>
          <label>Verse reference<input value={form.verseReferenceEn} onChange={(e) => update('verseReferenceEn', e.target.value)} /></label>
          <label>Verse text<textarea rows={3} value={form.verseTextEn} onChange={(e) => update('verseTextEn', e.target.value)} /></label>
          <label>Reflection<textarea rows={5} value={form.reflectionEn} onChange={(e) => update('reflectionEn', e.target.value)} /></label>
        </fieldset>
        <fieldset>
          <legend>Kannada</legend>
          <label>Title<input value={form.titleKn} onChange={(e) => update('titleKn', e.target.value)} /></label>
          <label>Series<input value={form.seriesKn} onChange={(e) => update('seriesKn', e.target.value)} /></label>
          <label>Verse reference<input value={form.verseReferenceKn} onChange={(e) => update('verseReferenceKn', e.target.value)} /></label>
          <label>Verse text<textarea rows={3} value={form.verseTextKn} onChange={(e) => update('verseTextKn', e.target.value)} /></label>
          <label>Reflection<textarea rows={5} value={form.reflectionKn} onChange={(e) => update('reflectionKn', e.target.value)} /></label>
        </fieldset>
        <div className="span-2 row">
          <label>Speaker<input value={form.speaker} onChange={(e) => update('speaker', e.target.value)} /></label>
          <div className="date-fields">
            <span className="date-fields-label">Date</span>
            <div className="date-fields-row">
              <label>
                Day
                <select
                  value={dateDay}
                  onChange={(e) => setDateDay(Number(e.target.value))}
                >
                  {Array.from({ length: maxDay }, (_, i) => i + 1).map((d) => (
                    <option key={d} value={d}>{d}</option>
                  ))}
                </select>
              </label>
              <label>
                Month
                <select
                  value={dateMonth}
                  onChange={(e) => setMonth(Number(e.target.value))}
                >
                  {MONTHS.map((name, i) => (
                    <option key={name} value={i + 1}>{name}</option>
                  ))}
                </select>
              </label>
              <label>
                Year
                <select
                  value={dateYear}
                  onChange={(e) => setYear(Number(e.target.value))}
                >
                  {YEARS.map((y) => (
                    <option key={y} value={y}>{y}</option>
                  ))}
                </select>
              </label>
            </div>
            <p className="muted date-preview">
              Displays as: {formatDevotionDate(dateDay, dateMonth, dateYear)}
            </p>
          </div>
          <label className="checkbox">
            <input type="checkbox" checked={form.published} onChange={(e) => update('published', e.target.checked)} />
            Published
          </label>
        </div>
        <div className="span-2">
          <button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Save devotion'}</button>
        </div>
      </form>
    </div>
  );
}
