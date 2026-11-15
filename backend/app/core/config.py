import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()

@dataclass(frozen=True)
class Settings:
    db_connection_string: str = os.getenv("DATABASE_CONNECTION_STRING", "")
    jwt_secret: str = os.getenv("JWT_SECRET", "dev-secret-change-me-please-use-a-32-byte-key")
    jwt_expire_minutes: int = int(os.getenv("JWT_EXPIRE_MINUTES", "480"))
    frontend_origin: str = os.getenv("FRONTEND_ORIGIN", "http://localhost:5173")
    payment_commission_percent: float = float(os.getenv("PAYMENT_COMMISSION_PERCENT", "10"))
    allow_admin_registration: bool = os.getenv("ALLOW_ADMIN_REGISTRATION", "true").lower() == "true"

settings = Settings()
