# 🛡️ App Status & Access Control System

## 🚀 Overview
A robust, server-driven access control system designed to manage application availability in real-time. This feature allows administrators to remotely toggle the application into **Maintenance Mode** or **Blocked Mode** (e.g., for non-payment), instantly updating the user interface with a premium, animated experience.

## ✨ Key Features

### 1. 🏗️ Two Distinct Modes
*   **🟣 Maintenance Mode**: A friendly, purple-themed interface informing users that the app is undergoing improvements. Features a "Work in Progress" animation and reassuring copy ("We're making things better").
*   **🔴 Blocked Mode**: A strict, red-themed interface for restricted access. clear messaging ("Access Restricted") and a direct call-to-action to "Contact Support".

### 2. 🎨 Premium & Dynamic UI
*   **Glassmorphism Design**: Modern, frosted-glass cards and translucent elements.
*   **Alive & Breathing**: Backgrounds feature slowly rotating gradients and pulsing circular elements (`AnimatedBackgroundCircles`) to keep the static screens feeling alive.
*   **Lottie Animations**: High-quality vector animations correspond to the specific status state (Gears for maintenance, Lock for blocked).
*   **Smooth Transitions**: All state changes use `FadeTransition` and animated gradients for a polished, jank-free experience.

### 3. 🛡️ Robust Architecture
*   **App Initializer**: A dedicated interceptor (`AppInitializer`) runs at startup to verify app status before the home screen ever loads, preventing unauthorized access.
*   **Fail-Open Strategy**: If the status API is unreachable, the system defaults to "Active" mode, ensuring users are never accidentally locked out due to network errors.
*   **Mock & Debug Capabilities**: Includes a "Mock Mode" for testing and video demonstrations, allowing developers to simulate network delays and forced states without a backend.

## 📱 User Flow
1.  **Launch**: User sees a branded "Establishing Secure Connection..." loading screen.
2.  **Check**: The app queries the specific API endpoint (`/Status/GetStatus`) for the App ID.
3.  **Action**:
    *   **If Active**: User proceeds smoothly to the Home Screen.
    *   **If Maintenance**: User is redirected to the Maintenance Screen.
    *   **If Blocked**: User is redirected to the Blocked Screen.

## 🛠️ Tech Stack
*   **Flutter & Dart**
*   **Flutter Bloc** (Cubit & Provider) for state management.
*   **Dio** for reliable network requests.
*   **Lottie** for vector animations.
*   **Glassmorphism** styling.
