from sqlalchemy import Column, Integer, Boolean, JSON, ForeignKey
from sqlalchemy.orm import relationship
from app.db.base import Base

class Cart(Base):
    __tablename__ = "carts"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    products = Column(JSON, nullable=False)
    checkout_status = Column(Boolean, default=False)
    user = relationship(
        "User",
        back_populates="carts"
    )