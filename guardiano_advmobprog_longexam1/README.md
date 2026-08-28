# Advance Mobile Programming Long Exam 1

Student: Venz Ygnaz O. Guardiano  
Section: INF231  
Course: CTADMOBL - Advance Mobile Programming

---

## Overview

This Flutter project demonstrates advanced mobile programming concepts, specifically focusing on mobile-to-web transactions, REST API consumption, state handling, and modular software architecture.

---

## Architectural Pattern: Models -> Services -> Screens

For this implementation, I applied the Model-Service-Screen design pattern to keep the codebase clean, maintainable, and decoupled:

- Models:Handle data serialization and type safety. They convert raw JSON payloads received from the backend/API endpoints into strongly-typed Dart objects (e.g., mapping cart and product structures via `fromJson()` factory methods).
- Services: Manage the asynchronous network layer (`http` requests). Services handle API endpoints, status codes, and error parsing, then return structured model objects to the caller.
- Screens:Focus purely on UI/UX presentation and state rendering. Screens trigger service methods, manage local widget states (like loading spinners), and display data mapped from models.

---

## Discussion & Analysis

The Cart Model converts the API's JSON into Cart and CartProduct objects. The Cart Service calls the cart endpoints and returns the parsed data. The Cart Screen calls the service and displays the cart items.

To reach the same detail_screen.dart, the Cart Screen takes the id from the tapped cart item and uses getById (ProductService's getProductById) to fetch the full Product, then passes it to the same ProductDetailsScreen used by the product listing. This is how getById connects a cart item to the detail screen.

The updated design pattern still follows Model-Service-Screen, but now shows one screen (Cart Screen) combining two services (CartService and ProductService) to complete a feature.
