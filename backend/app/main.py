from fastapi import FastAPI
from app.db import session
from app.db.base import Base
from app.api.v1 import auth
from app.api.v1 import products
from app.api.v1 import cart
from app.api.v1 import orders
from app.api.v1 import external_products
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Ecommerce API")


# create tables
Base.metadata.create_all(bind=session.engine)


# register routers
app.include_router(auth.router)
app.include_router(products.router)
app.include_router(cart.router, prefix="/api/v1")
app.include_router(orders.router, prefix="/api/v1")
app.include_router(external_products.router, prefix="/api/v1")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://denish1633.github.io",
        "http://localhost:3000",   # optional for local web
        "http://localhost:8000",   # optional for testing
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "Ecommerce API running 🚀"}
