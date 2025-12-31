from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from uuid import uuid4

from app.db.session import get_db
from app.models.order import Order
from app.models.order_item import OrderItem
from app.schemas.order import OrderCreate
from app.schemas.order_response import OrderResponse
from app.core.auth import get_current_user

router = APIRouter(prefix="/orders", tags=["Orders"])

@router.post("", response_model=OrderResponse, status_code=status.HTTP_201_CREATED)
def create_order(
    payload: OrderCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    if not payload.items:
        raise HTTPException(
            status_code=400,
            detail="Order must contain at least one item",
        )

    order = Order(
        user_id=current_user.id,
        total_amount=payload.total_amount,
        status="PENDING",
        tracking_number=f"{uuid4().hex[:8]}-{current_user.id}",
    )

    db.add(order)
    db.flush()  # get order.id

    order_items = [
        OrderItem(
            order_id=order.id,
            product_id=item.product_id,
            quantity=item.quantity,
            price=item.price,
        )
        for item in payload.items
    ]

    db.add_all(order_items)
    db.commit()
    db.refresh(order)

    return order


@router.get("", response_model=list[OrderResponse])
def get_my_orders(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return (
        db.query(Order)
        .filter(Order.user_id == current_user.id)
        .order_by(Order.created_at.desc())
        .all()
    )

@router.get("/{order_id}", response_model=OrderResponse)
def get_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    order = (
        db.query(Order)
        .filter(
            Order.id == order_id,
            Order.user_id == current_user.id,
        )
        .first()
    )

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    return order
