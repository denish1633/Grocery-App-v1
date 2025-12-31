# backend/app/api/v1/external_products.py
import urllib.request
import json
from urllib.error import HTTPError, URLError
from fastapi import APIRouter

router = APIRouter()

@router.get("/external-products/{category}")
def get_external_products(category: str):
    """
    Fetch products from Open Food Facts by category.
    """
    url = f"https://world.openfoodfacts.org/category/{category}.json"
    try:
        with urllib.request.urlopen(url) as resp:
            status = resp.getcode()
            if status != 200:
                return {"error": "Unable to fetch products"}
            raw = resp.read()
            data = json.loads(raw.decode("utf-8"))
    except HTTPError as e:
        return {"error": f"HTTP error: {e.code}"}
    except URLError as e:
        return {"error": f"URL error: {e.reason}"}
    except Exception:
        return {"error": "Unable to fetch products"}

    products = []
    for item in data.get("products", []):
        products.append({
            "name": item.get("product_name"),
            "brand": item.get("brands"),
            "image_url": item.get("image_front_url"),
            "code": item.get("code"),
        })
    print(f"Fetched {len(products)} products for category '{category}':")
    for p in products[:5]:  # print only first 5 to avoid too much output
        print(p)
        
    return products
