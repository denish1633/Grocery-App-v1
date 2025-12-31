# 🛒 Grocery App – Flutter & FastAPI

A full-stack grocery shopping application built with **Flutter** for the frontend and **FastAPI (Python)** for the backend.  
The app supports user authentication, product browsing, cart management, and order placement.

Frontend is deployed on **GitHub Pages**, while the backend is hosted separately as a REST API.

---
## 📱 Screens & Features

### 🔐 Authentication Screenså
**Login Screen**
- User login using email/username and password
- JWT-based authentication
- Error handling for invalid credentials
  
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 25 25" src="https://github.com/user-attachments/assets/faa0725b-2f35-401a-ae13-c823f3edd36f" />

**Register Screen**
- New user registration
- Input validation
- Secure password hashing (backend)
  
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 26 01" src="https://github.com/user-attachments/assets/b6a9d248-cbc8-4731-bc2e-13f66be3ee8b" />

---

### 🏠 Home Screen
- Displays available grocery products
- Product name, price, and image
- Quick access to add items to cart
- Pull-to-refresh to reload products
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 26 55" src="https://github.com/user-attachments/assets/3db57ca9-e198-4009-a602-0b1a5c1bc9a5" />

---

### 🛍 Product Details Screen
- Detailed view of selected product
- Product description and price
- Quantity selection
- Add to cart functionality
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 26 59" src="https://github.com/user-attachments/assets/2f7749df-f028-4fa1-8751-26bffc3aa6fd" />

---

### 🛒 Cart Screen
- List of items added to cart
- Increase / decrease item quantity
- Remove items from cart
- Displays total price dynamically
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 27 07" src="https://github.com/user-attachments/assets/b9e056f8-d49f-47f4-888c-e376dfad1f53" />
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 27 13" src="https://github.com/user-attachments/assets/a117cd5e-a442-46df-874c-d327b3fb0a1a" />

---

### 📦 Order Summary / Checkout Screen
- Shows final list of cart items
- Displays total payable amount
- Places order via backend API
- Handles order success/failure states

---

### 📜 Orders Screen
- Displays user’s past orders
- Order date, total amount, and status
- Data fetched securely using JWT token
<img width="293" height="633" alt="Simulator Screenshot - iPhone 16e - 2025-12-31 at 14 27 17" src="https://github.com/user-attachments/assets/43f687be-5b9e-4738-8bcb-b9d37a271d03" />

---

## 🧠 Tech Stack

### Frontend
- Flutter (Web)
- GetX (state management)
- HTTP package for API calls

### Backend
- FastAPI (Python)
- SQLAlchemy ORM
- JWT Authentication
- PostgreSQL / SQLite (configurable)

### Hosting
- Flutter Web → **GitHub Pages**
- FastAPI Backend → **Render**
- Database → **Render / External DB**

---

## 🗂 Project Structure
```
.
├── backend
│   ├── app
│   │   ├── __init__.py
│   │   ├── __pycache__
│   │   ├── api
│   │   │   └── v1
│   │   │   ├── __pycache__
│   │   │   ├── auth.py
│   │   │   ├── cart.py
│   │   │   ├── external_products.py
│   │   │   ├── orders.py
│   │   │   └── products.py
│   │   ├── core
│   │   │   ├── __pycache__
│   │   │   ├── auth.py
│   │   │   ├── config.py
│   │   │   └── security.py
│   │   ├── crud
│   │   │   ├── __pycache__
│   │   │   ├── cart.py
│   │   │   ├── order.py
│   │   │   ├── product.py
│   │   │   └── user.py
│   │   ├── db
│   │   │   ├── __pycache__
│   │   │   ├── base.py
│   │   │   └── session.py
│   │   ├── main.py
│   │   ├── models
│   │   │   ├── __pycache__
│   │   │   ├── cart.py
│   │   │   ├── order_item.py
│   │   │   ├── order.py
│   │   │   ├── product.py
│   │   │   └── user.py
│   │   ├── schemas
│   │   │   ├── __pycache__
│   │   │   ├── cart.py
│   │   │   ├── order_response.py
│   │   │   ├── order.py
│   │   │   ├── product.py
│   │   │   └── user.py
│   │   └── utils
│   │       ├── __pycache__
│   │       └── jwt.py
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── pyproject.toml
│   ├── requirements.txt
│   └── venv
└── frontend
    ├── ai_grocery_app.iml
    ├── analysis_options.yaml
    ├── android
    ├── assets
    ├── build
    ├── devtools_options.yaml
    ├── flutter_01.png
    ├── ios
    ├── lib
    │   ├── config
    │   │   ├── constants.dart
    │   │   └── theme.dart
    │   ├── controllers
    │   │   ├── AuthController.dart
    │   │   ├── CartController.dart
    │   │   ├── OrderController.dart
    │   │   ├── ProductController.dart
    │   │   └── WishlistController.dart
    │   ├── main.dart
    │   ├── models
    │   │   ├── cart.dart
    │   │   ├── order.dart
    │   │   ├── product.dart
    │   │   └── user.dart
    │   ├── services
    │   │   ├── AuthService.dart
    │   │   ├── CartService.dart
    │   │   ├── OrderService.dart
    │   │   └── ProductService.dart
    │   ├── utils
    │   │   ├── helpers.dart
    │   │   ├── storage.dart
    │   │   └── validators.dart
    │   ├── views
    │   │   ├── AccountScreen.dart
    │   │   ├── CartScreen.dart
    │   │   ├── CategoryScreen.dart
    │   │   ├── data.json
    │   │   ├── ExploreScreen.dart
    │   │   ├── FavouriteScreen.dart
    │   │   ├── HomeScreen.dart
    │   │   ├── LoginScreen.dart
    │   │   ├── product_detail_page.dart
    │   │   ├── RegisterScreen.dart
    │   │   ├── ShopScreen.dart
    │   │   └── welcome.dart
    │   └── widgets
    │       ├── banner_carousel.dart
    │       ├── bottom_nav.dart
    │       ├── custom_button.dart
    │       ├── custom_textfield.dart
    │       ├── product_card.dart
    │       └── product_row.dart
    ├── linux
    ├── macos
    ├── poetry.lock
    ├── pubspec.lock
    ├── pubspec.yaml
    ├── pyproject.toml
    ├── README.md
    ├── test
    ├── venv
    ├── web
    └── windows
```
