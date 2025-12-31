from pydantic import BaseModel, condecimal, conint
from typing import List
from decimal import Decimal


class OrderItemCreate(BaseModel):
    product_id: int   # BIG numbers OK
    quantity: conint(gt=0)
    price: condecimal(max_digits=10, decimal_places=2)


class OrderCreate(BaseModel):
    total_amount: condecimal(max_digits=10, decimal_places=2)
    items: List[OrderItemCreate]
