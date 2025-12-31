from pydantic import BaseModel
from typing import List


class CartProduct(BaseModel):
    product_id: str
    name: str
    price: float
    image_url: str | None
    quantity: int


class CartUpsert(BaseModel):
    products: List[CartProduct]


class CartOut(BaseModel):
    id: int
    user_id: int
    products: List[CartProduct]
    checkout_status: bool

    class Config:
        from_attributes = True
