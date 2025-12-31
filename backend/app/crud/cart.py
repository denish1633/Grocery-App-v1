from sqlalchemy.orm import Session
from app.models.cart import Cart
from app.schemas import cart as schemas


def upsert_cart(db: Session, user_id: int, payload: schemas.CartUpsert):
    cart = db.query(Cart).filter(
        Cart.user_id == user_id,
        Cart.checkout_status == False
    ).first()

    if not cart:
        cart = Cart(
            user_id=user_id,
            products=[p.dict() for p in payload.products],
        )
        db.add(cart)
    else:
        cart.products = [p.dict() for p in payload.products]

    db.commit()
    db.refresh(cart)
    return cart


def checkout_cart(db: Session, user_id: int):
    cart = db.query(Cart).filter(
        Cart.user_id == user_id,
        Cart.checkout_status == False
    ).first()

    if not cart:
        return None

    cart.checkout_status = True
    db.commit()
    db.refresh(cart)
    return cart
