from pydantic import BaseModel, Field
class MessageIn(BaseModel):
    contenido_mensaje: str = Field(min_length=1, max_length=2000)
