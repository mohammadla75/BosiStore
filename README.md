# 🛍️ Bosi Store - iOS E-Commerce App (SwiftUI)

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-17.6+-blue.svg)
![UI](https://img.shields.io/badge/UI-Glassmorphism-purple.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-success.svg)

A premium, fully functional iOS E-Commerce application built entirely with **SwiftUI**. This project serves as a comprehensive template showcasing a modern **Glassmorphism design language**, smooth animations, and complete local data persistence without the need for a backend.

> **Note:** This app is designed as a standalone, offline-first application. All user data, carts, reviews, and media are securely stored locally on the device.

---

## ✨ UI / UX Highlights
- **Glassmorphism Design:** Beautiful translucent cards, ultra-thin materials, and vibrant animated mesh gradients that give the app a luxurious and premium feel.
- **Hero Animations:** Smooth `matchedGeometryEffect` transitions when navigating from the product list to the product details.
- **Haptic Feedback:** Tactile responses integrated into cart actions for a premium user experience.

---

## 🚀 Key Features

### 🛒 Shopping Experience
- **Dynamic Product List:** Search, filter by categories, and view products with special discount badges.
- **Detailed Product Pages:** View multiple images, full descriptions, specifications, and calculate real-time savings.
- **Smart Cart System:** Add/remove items, manage quantities, calculate subtotals, and total discounts.

### 🔐 User Management & Security
- **Local Authentication:** Full Login and Registration system with validation.
- **Privacy & Terms Enforcement:** Users must agree to Terms & Conditions before registering. Secure local data policy emphasized.
- **Address Book:** Users can add multiple delivery addresses.
- **CoreLocation Integration:** Automatically fetch and save the user's GPS coordinates (Latitude/Longitude) for accurate deliveries.

### ⭐ Social & Reviews
- **Product Reviews:** Users can leave star ratings and text comments.
- **Media Attachments:** Integrated with `PhotosUI` and Camera. Users can attach photos and videos to their reviews (saved to the local file system).

### 🌍 Localization (i18n)
Full Multi-language support with dynamic switching inside the app settings:
- 🇺🇸 English (Default)
- 🇨🇳 Chinese (中文)
- 🇸🇦 Arabic (العربية - with full **Right-to-Left (RTL)** layout support)

---

## 🛠 Tech Stack & Architecture
- **Framework:** SwiftUI
- **Language:** Swift 5.9
- **Architecture:** MVVM (Model-View-ViewModel)
- **Data Persistence:** `UserDefaults` (Codable models) & Local File System (`FileManager` for media).
- **Concurrency:** `async/await` for media processing.
- **Native APIs:** `CoreLocation`, `PhotosUI`, `UIImpactFeedbackGenerator`.

---

## 💻 Requirements
- iOS 17.6+
- Xcode 15.0+
- Swift 5.9+

---

## ⚙️ Installation & Running

1. Clone the repository:
   ```bash
   git clone https://github.com/mohammadla75/BosiStore.git
