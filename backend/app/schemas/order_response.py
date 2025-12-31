from pydantic import BaseModel
from decimal import Decimal
from datetime import datetime
from typing import List


class OrderItemResponse(BaseModel):
    product_id: int
    quantity: int
    price: Decimal

    class Config:
        from_attributes = True


class OrderResponse(BaseModel):
    id: int
    total_amount: Decimal
    status: str
    tracking_number: str
    created_at: datetime
    items: List[OrderItemResponse]

    class Config:
        from_attributes = True
