from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth

from app.config import ADMIN_EMAILS
from app.firebase import init_firebase

security = HTTPBearer()


def verify_admin(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> dict:
    init_firebase()
    token = credentials.credentials
    try:
        decoded = auth.verify_id_token(token)
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid token: {exc}",
        ) from exc

    email = (decoded.get("email") or "").lower()
    if ADMIN_EMAILS and email not in ADMIN_EMAILS:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not an authorized admin",
        )

    return decoded
