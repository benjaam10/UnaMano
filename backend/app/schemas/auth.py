from enum import Enum
from pydantic import BaseModel, Field, ConfigDict

class Role(str, Enum):
    ADMIN = "Admin"
    CLIENTE = "Cliente"
    ESTUDIANTE = "Estudiante"

class RegisterRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")
    role: Role
    email: str = Field(min_length=1, max_length=100)
    password: str = Field(min_length=1, max_length=128)
    rut: str | None = Field(default=None, max_length=12)
    nombre1: str | None = Field(default=None, max_length=50)
    nombre2: str | None = Field(default=None, max_length=50)
    apellido1: str | None = Field(default=None, max_length=50)
    apellido2: str | None = Field(default=None, max_length=50)
    fecha_nacimiento: str | None = None
    telefono: str | None = Field(default=None, max_length=15)
    universidad: str | None = Field(default=None, max_length=100)
    carrera: str | None = Field(default=None, max_length=100)
    calle: str | None = Field(default=None, max_length=200)
    numero: str | None = Field(default=None, max_length=20)
    dpto: str | None = Field(default=None, max_length=50)
    referencia: str | None = Field(default=None, max_length=200)
    id_region: int | None = Field(default=None, gt=0)
    id_comuna: int | None = Field(default=None, gt=0)

class LoginRequest(BaseModel):
    email: str = Field(min_length=1, max_length=100)
    password: str = Field(min_length=1, max_length=128)

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
