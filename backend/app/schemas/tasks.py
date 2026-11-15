from datetime import datetime
from decimal import Decimal
from pydantic import BaseModel, Field, ConfigDict

class AddressIn(BaseModel):
    model_config = ConfigDict(extra="forbid")
    calle: str = Field(min_length=1, max_length=200)
    numero: str = Field(min_length=1, max_length=20)
    dpto: str | None = Field(default=None, max_length=50)
    referencia: str | None = Field(default=None, max_length=200)
    id_region: int = Field(gt=0)
    id_comuna: int = Field(gt=0)

class TaskCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")
    titulo_tarea: str = Field(min_length=1, max_length=100)
    descripcion_tarea: str = Field(min_length=1, max_length=500)
    pago_ofrecido_tarea: Decimal = Field(gt=0, max_digits=10, decimal_places=2)
    fecha_inicio_tarea: datetime
    id_categoria_tarea: int = Field(gt=0)
    id_nombre_tarea: int = Field(gt=0)
    direccion: AddressIn

class TaskUpdate(BaseModel):
    titulo_tarea: str = Field(min_length=1, max_length=100)
    descripcion_tarea: str = Field(min_length=1, max_length=500)
    pago_ofrecido_tarea: Decimal = Field(gt=0, max_digits=10, decimal_places=2)
    fecha_inicio_tarea: datetime
    id_categoria_tarea: int = Field(gt=0)
    id_nombre_tarea: int = Field(gt=0)
    direccion: AddressIn
