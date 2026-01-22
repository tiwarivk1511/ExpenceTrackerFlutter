# Expense Tracker App

A modern, futuristic expense tracker application built with Flutter. It allows users to manage their expenses, including image uploads, local storage, and synchronization with a server.

## Features

- **Authentication**: Secure user authentication including sign-in, sign-up, and forgot password functionality.
- **CRUD Operations**: Full Create, Read, Update, and Delete capabilities for expenses.
- **Image Upload**: Attach images to expenses for better record-keeping.
- **Local Storage**: Uses SQLite to store all expenses locally, allowing for offline access.
- **Data Privacy**: Ensures that each user can only access their own expense data.
- **Data Sync**: A mechanism to sync local data with a remote server.
- **Modern UI**: A sleek, futuristic interface with a dark theme and custom gradients.
- **Permission Handling**: Gracefully requests necessary permissions (camera, storage) at runtime.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `provider`
- **Networking**: `dio`
- **Local Database**: `sqflite`
- **Session Management**: `shared_preferences`
- **Image Handling**: `image_picker`
- **Permissions**: `permission_handler`

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository**
   ```sh
   git clone https://github.com/tiwarivk1511/ExpenceTrackerFlutter.git
   cd expence_tracker
   ```

2. **Install dependencies**
   Run the following command in your terminal:
   ```sh
   flutter pub get
   ```

3. **API Configuration**
   The app is configured to work with placeholder API endpoints in `lib/repository/auth_repository.dart`. You will need to replace these with your own backend service.

### Running the Application

1. **Connect a device** or start an emulator/simulator.

2. **Run the app**
   Use the following command to run the application:
   ```sh
   flutter run
   ```

This will launch the app on your connected device or emulator.
