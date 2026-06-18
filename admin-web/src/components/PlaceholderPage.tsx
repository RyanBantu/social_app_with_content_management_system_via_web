interface PlaceholderPageProps {
  title: string;
  description?: string;
}

export default function PlaceholderPage({ title, description }: PlaceholderPageProps) {
  return (
    <div>
      <h1>{title}</h1>
      <div className="card placeholder-card">
        <p className="placeholder-badge">Coming soon</p>
        <p>
          {description ??
            'This section is not enabled for the demo yet. Use Daily Devotion to update live content in the app.'}
        </p>
      </div>
    </div>
  );
}
