from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import relationship
from app.db.base import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    username = Column(String, unique=True, index=True, nullable=False)

    
    carts = relationship("Cart", back_populates="user")
    orders = relationship(
        "Order",
        back_populates="user",
        cascade="all, delete-orphan",
    )