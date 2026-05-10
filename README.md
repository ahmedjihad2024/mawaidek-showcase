# Mawadk - Advanced Medical Services & Appointment Booking

Mawadk is a high-performance, multi-platform Flutter application designed for seamless medical service discovery and appointment management. This repository is a sanitized showcase version, highlighting professional coding standards, clean architecture, and premium UI/UX design.

---

## 🏛️ Architecture

The project follows the **Clean Architecture** pattern with **BLoC Pattern** for state management, ensuring strict separation of concerns and testability.

```
┌─────────────────────────────────────────────────┐
│         Presentation Layer (UI)                 │
│  • Views/Screens  • Widgets  • BLoC             │
│  • Routes Manager • Theme Manager              │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│         Domain Layer (Business Logic)            │
│  • Use Cases  • Repositories  • Models          │
│  • Interfaces  • Business Logic                 │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│        Data Layer (Database & Network)          │
│  • Data Sources  • Repositories Impl            │
│  • Network  • Local Storage  • Mappers          │
└─────────────────────────────────────────────────┘
```

### Core Architecture Principles:
- **Separation of Concerns:** Distinct layers for UI, logic, and data.
- **Dependency Injection:** Centralized service locator using `GetIt`.
- **Error Handling:** Unified error handling using the `Either` (Success/Failure) pattern from `dartz`.
- **Reactive State:** State management driven by `flutter_bloc`.

---

## 🚀 Key Features (Showcase Flow)

### 1. **Home Dashboard** (`lib/presentation/views/home`)
The central hub of the application.
*   **Hero Banners**: Visual promotional sliders.
*   **Service Categories**: Quick navigation to Doctors, Clinics, and Hospitals.
*   **Personalized Experience**: Upcoming appointments and nearby providers.

### 2. **Provider Profiles (Services)** (`lib/presentation/views/services`)
A professional detail view for medical providers.
*   **Interactive Maps**: Real-time location visualization.
*   **Department Filtering**: Browse services and specialties within the center.
*   **Social Proof**: Integrated rating and review summaries.

### 3. **Smart Booking System** (`lib/presentation/views/appointment_booking`)
*   **Live Scheduling**: Dynamic calendar with real-time slot availability.
*   **Confirmation Flow**: Secure multi-step booking validation.

### 4. **Appointment Management** (`lib/presentation/views/booking_details`)
*   **Booking Status**: High-fidelity tracking of medical appointments.
*   **Details View**: Comprehensive summary of appointment metadata.

---

## 🛠️ Technologies Used

### Core Framework
- **Flutter & Dart**: Latest stable versions.
- **State Management**: `flutter_bloc`, `equatable`.
- **DI**: `get_it`.

### Networking & Data
- **Dio**: Advanced HTTP client with custom interceptors for security and logging.
- **Dartz**: Functional programming types (Either/Failure).
- **Shared Preferences**: Persistent local storage.

### UI & UX
- **Responsiveness**: `flutter_screenutil` for pixel-perfect design across devices.
- **Animations**: `flutter_animate` and custom visibility transitions.
- **Components**: `carousel_slider`, `flutter_svg`, `pull_to_refresh`, `shimmer`.

### System Services
- **Firebase**: Core, Messaging, and Cloud configurations.
- **Localization**: Arabic (RTL) and English (LTR) via `easy_localization`.
- **Geolocator**: Real-time location and distance calculation.

---

## 📂 Project Structure

```
lib/
├── app/                  # Application-wide config (DI, Constants, Routes)
├── data/                 # Data Sources, Repositories Impl, Mappers, API
├── domain/               # Business Models, Repository Interfaces, Use Cases
└── presentation/         # UI Layers (Views, Widgets, BLoC, Resources)
```

---

## 🔐 Sanitization Notice
This repository is a **Portfolio Demonstration**. 
1. **Sensitive Data**: All API keys, Firebase secrets, and Base URLs are replaced with placeholders.
2. **Hidden Modules**: Non-core features (Auth, Chat, Support) are code-hidden to focus on the primary high-impact flow.
3. **Private Info**: Internal emails and production endpoints are removed.

---

**Status:** Professional Portfolio Version  
**Author:** Ahmed Jihad (mawadk)
