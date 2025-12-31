from sqlalchemy.orm import Session
from app.models.order import Order
from app.models.order_item import OrderItem
from app.models.cart import Cart
from app.schemas import cart as cart_schemas
from typing import List

def create_order_from_cart(db: Session, user_id: int) -> Order | None:
    # Fetch user's active cart
    cart_items = db.query(Cart).filter(Cart.user_id == user_id).all()
    if not cart_items:
        return None

    # Calculate total
    total = sum(item.product.price * item.quantity for item in cart_items)

    # Create order
    order = Order(user_id=user_id, total=total)
    db.add(order)
    db.flush()  # get order.id

    # Add items
    for item in cart_items:
        order_item = OrderItem(
            order_id=order.id,
            product_id=item.product_id,
            quantity=item.quantity
        )
        db.add(order_item)
        db.delete(item)  # clear cart

    db.commit()
    db.refresh(order)
    return order


def get_orders_by_user(db: Session, user_id: int) -> List[Order]:
    return db.query(Order).filter(Order.user_id == user_id).order_by(Order.created_at.desc()).all()
