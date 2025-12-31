from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    email: EmailStr

class UserLogin(BaseModel):
    email: EmailStr
    password: str
    
class UserCreate(UserBase):
    password: str
    username: str
    


class UserOut(BaseModel):
    id: int
    email: str
    username: str | None = None
    access_token: str | None = None
    token_type: str | None = None

    class Config:
        from_attributes = True
