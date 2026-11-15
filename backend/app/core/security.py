import base64
import hashlib
import hmac
from datetime import datetime, timedelta, timezone
from typing import Any

import jwt

from app.core.config import settings

ALGORITHM = "HS256"

def hash_password(password: str) -> str:
    salt = os_random(16)
    digest = hashlib.scrypt(password.encode("utf-8"), salt=salt, n=2**14, r=8, p=1)
    return "scrypt$16384$8$1$" + b64(salt) + "$" + b64(digest)

def verify_password(password: str, stored: str) -> bool:
    try:
        scheme, n, r, p, salt_s, digest_s = stored.split("$")
        if scheme != "scrypt":
            return False
        salt = b64d(salt_s)
        expected = b64d(digest_s)
        actual = hashlib.scrypt(password.encode("utf-8"), salt=salt, n=int(n), r=int(r), p=int(p))
        return hmac.compare_digest(actual, expected)
    except Exception:
        return False

def create_access_token(payload: dict[str, Any]) -> str:
    now = datetime.now(timezone.utc)
    data = dict(payload)
    data.update({"iat": int(now.timestamp()), "exp": now + timedelta(minutes=settings.jwt_expire_minutes)})
    return jwt.encode(data, settings.jwt_secret, algorithm=ALGORITHM)

def decode_access_token(token: str) -> dict[str, Any]:
    return jwt.decode(token, settings.jwt_secret, algorithms=[ALGORITHM])

def b64(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).decode("ascii")

def b64d(value: str) -> bytes:
    return base64.urlsafe_b64decode(value.encode("ascii"))

def os_random(n: int) -> bytes:
    import os
    return os.urandom(n)
