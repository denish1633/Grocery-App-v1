from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.crud import product as crud
from app.schemas import product as schemas
from app.db.session import get_db

router = APIRouter(prefix="/products", tags=["Products"])

@router.post("/", response_model=schemas.Product)
def create_product(product: schemas.ProductCreate, db: Session = Depends(get_db)):
    return crud.create_product(db, product)

@router.get("/", response_model=list[schemas.Product])
def list_products(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_products(db, skip=skip, limit=limit)
