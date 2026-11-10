PC16 – Automated Ordering Kiosk System
---

📌 Overview

This project is a console-based Dart application modeling a fast-food **Automated Ordering Kiosk System**. Developed across Weeks 9 through 11, the codebase showcases progressive Object-Oriented Programming (OOP) design patterns and modern asynchronous programming techniques in Dart.

The application handles menu storage, cart management, total calculation, polymorphic receipt output, audio prompts, and simulated non-blocking cloud bank payment verification.

---

🏗️ Architecture & Features

1. Object-Oriented Foundations & Encapsulation (Week 9)
Base Class (`OrderingKiosk`):** Encapsulates core kiosk fields including `kioskId`, `branchLocation`, and `isActive`.
Encapsulation:** Protects private state variables (`_dailyRevenue` and `_cart`) using private fields with leading underscores, exposing them safely via read-only unmodifiable getters (`dailyRevenue` and `currentCart`).
Collections:** Manages items using a pricing map (`Map<String, double>`) and item collections (`List<String>`).

2. Interface Contracts, Mixins & Inheritance (Week 10)
Abstract Class (`PrintableReceipt`):** Serves as an interface defining mandatory receipt logic (`printReceipt(double total)`).
Mixin (`AudioPrompts`):** Adds modular sound notification capabilities (`playAudioCue`) to target classes using the `with` keyword without polluting the main inheritance chain.
Inheritance & Polymorphism:**
   `SelfServiceKiosk`: Derived class customized for lobby touchscreen displays. Overrides `printReceipt()` to dispatch digital e-receipts.
   `DriveThruKiosk`: Derived class adopting `AudioPrompts` for audio alerts. Overrides `processCheckout()` and `printReceipt()` to process vehicle drive-thru orders and print physical slips.

3. Asynchronous Operations (Week 11)
Non-Blocking Payment Processing:** `processNetworkPayment(double total)` returns a `Future<bool>` and utilizes `Future.delayed(Duration(seconds: 2))` to simulate real-time cloud payment gateway verification.
`async` / `await` Flow:** Main engine operations await network approval asynchronously before updating daily revenue and printing receipts, ensuring non-blocking execution.
