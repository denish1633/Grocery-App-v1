from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.schemas import cart as schemas
from app.crud import cart as crud

router = APIRouter(prefix="/cart", tags=["Cart"])


@router.put("/{user_id}", response_model=schemas.CartOut)
def save_cart(
    user_id: int,
    payload: schemas.CartUpsert,
    db: Session = Depends(get_db),
):
    return crud.upsert_cart(db, user_id, payload)


@router.post("/{user_id}/checkout", response_model=schemas.CartOut)
def checkout(
    user_id: int,
    db: Session = Depends(get_db),
):
    cart = crud.checkout_cart(db, user_id)
    if not cart:
        raise HTTPException(404, "No active cart")
    return cart
