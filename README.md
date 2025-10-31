# School Management System

A secure multi-role login system for a school management application built with Flutter and Node.js.

## Features

- Multi-role authentication (Admin, Teacher, Parent)
- Secure JWT-based authentication
- Role-specific dashboards
- Biometric authentication
- Secure storage for sensitive data
- Form validation
- Password change functionality

## Tech Stack

### Frontend
- Flutter
- Provider for state management
- flutter_secure_storage for secure data storage
- JWT handling
- Biometric authentication
- Form validation

### Backend
- Node.js
- Express.js
- MongoDB with Mongoose
- JWT for authentication
- bcrypt for password hashing
- Input validation with express-validator

## Setup Instructions

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a .env file with the following variables:
   ```
   MONGODB_URI=mongodb://localhost:27017/school_app
   JWT_SECRET=your-secure-secret-key-here
   PORT=3000
   ```

4. Start the server:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd frontend/school_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- POST /api/auth/login - Login user
- POST /api/auth/register - Register new user
- POST /api/auth/change-password - Change password (protected route)

## Security Features

- Password hashing with bcrypt
- JWT token authentication
- Secure storage on mobile devices
- Input validation and sanitization
- Protected API routes
- Biometric authentication option

## Directory Structure

### Frontend
```
lib/
├── models/
│   └── user.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── login_screen.dart
│   └── dashboard/
├── services/
└── utils/
```

### Backend
```
src/
├── models/
│   └── user.js
├── controllers/
│   └── auth.js
├── routes/
│   └── auth.js
├── middleware/
│   └── auth.js
└── index.js
```