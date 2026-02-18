# GymTracker

A robust, offline-first gym tracking application built with Flutter, designed around the **Push/Pull/Legs (PPL)** routine split.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2D2D2D?style=for-the-badge&logo=riverpod&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

## ✨ Features

*   **PPL Routine**: Structured workflow for Push, Pull, and Legs workout days.
*   **Smart Logging**:
    *   Track **Set**, **Reps**, **Weight**, and **RPE**.
    *   **Previous Performance**: Automatically sees what you did last time for each exercise.
    *   **Progress Indicators**: immediate feedback on your performance:
        *   ▲ **Progressed**: You beat your last session!
        *   ▼ **Regressed**: Performance dropped (it happens).
        *   = **Same**: Maintained performance.
        *   ★ **New**: First time logging this exercise.
*   **Exercise Library**: Data model for exercises, muscle groups (Chest, Back, Legs, etc.), and equipment types.
*   **Offline First**: All data is stored locally using SQLite (via Drift), so it works perfectly without internet.
*   **Modern UI**: Built with **Material 3**, featuring:
    *   Dark / Light mode support (respects system settings).
    *   Custom animated widgets (`ExerciseCard`, `SetInputRow`).
    *   Google Fonts (Inter).

## 🏗️ Architecture

This project strictly follows **Clean Architecture** to ensure scalability, testability, and separation of concerns.

### Layers

1.  **Domain Layer** (Pure Dart):
    *   **Entities**: Core business objects (`Exercise`, `SetLog`, `WorkoutSession`).
    *   **Use Cases**: Encapsulate business logic (`SaveSet`, `CalculateProgress`, `GetPreviousPerformance`).
    *   **Repositories**: Abstract interfaces defining data operations.
    *   **Failures**: Typed error hierarchy (`DatabaseFailure`, `ValidationFailure`, etc.).

2.  **Data Layer**:
    *   **Drift / SQLite**: Local database implementation.
    *   **DAOs**: Data Access Objects for raw database queries.
    *   **Repositories**: Concrete implementations that map database entities to domain entities.

3.  **Presentation Layer** (Flutter):
    *   **State Management**: **Riverpod** 2.0 (`AsyncNotifierProvider`, `StateProvider`).
    *   **State**: Immutable state classes generated with **Freezed**.
    *   **UI**: Widgets logic is decoupled from business logic.

## 🛠️ Tech Stack

*   **Framework**: Flutter
*   **Language**: Dart
*   **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
*   **Database**: [drift](https://pub.dev/packages/drift) (SQLite abstraction)
*   **Immutability/Unions**: [freezed](https://pub.dev/packages/freezed)
*   **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart) (for Error Handling with `Either`)
*   **Testing**: `flutter_test`, `mocktail` (Unit & Widget tests)

## 🚀 Getting Started

### Prerequisites

*   Flutter SDK (3.7.0 or higher)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/gymtracker.git
    cd gymtracker
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run code generation:**
    Since this project uses Drift and Freezed, you need to generate the boilerplate code:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🧪 Testing

The project has comprehensive test coverage across all layers.

*   **Run all tests:**
    ```bash
    flutter test
    ```

*   **Test scope:**
    *   **Unit Tests**: Use Cases, Repositories, DAOs.
    *   **Widget Tests**: UI components (e.g., `ActiveWorkoutScreen` progress badges).

---
*Built with best practices by the Google DeepMind Advanced Agentic Coding Team.*
