# PocketBase Integration Setup Guide

This guide will help you configure your Flutter admin dashboard to work with PocketBase as the backend.

## Prerequisites

1. **PocketBase Installation**: Download and install PocketBase from [https://pocketbase.io/](https://pocketbase.io/)
2. **Running PocketBase**: Start PocketBase server on `http://127.0.0.1:8090` (default)

## Database Setup

### 1. Create Collections

In your PocketBase admin dashboard, create two collections:

#### Admins Collection

- **Name**: `admins`
- **Fields**:
  - `email` (Email type)
  - `name` (Text type)
  - `role` (Select type with options: `admin`, `student`)

#### Users Collection

- **Name**: `users`
- **Fields**:
  - `email` (Email type)
  - `name` (Text type)
  - `role` (Select type with options: `student` - default)

### 2. Create Admin User

1. Go to your PocketBase admin dashboard
2. Create a new record in the `admins` collection:
   - Email: `admin@example.com`
   - Name: `Admin User`
   - Role: `admin`

### 3. Create Test User

1. Create a new record in the `users` collection:
   - Email: `student@example.com`
   - Name: `Test Student`
   - Role: `student`

## Configuration

### Update PocketBase URL

Edit `lib/services/config_service.dart`:

```dart
// Replace this line:
static const String _prodBaseUrl = 'https://your-pocketbase-instance.com';

// With your actual PocketBase URL:
static const String _prodBaseUrl = 'https://your-actual-pocketbase-url.com';
```

### Environment Configuration

The app automatically detects the environment:

- **Development**: Uses `http://127.0.0.1:8090`
- **Production**: Uses your configured production URL

## Usage

### Login as Admin

1. Open the app
2. Select "Admin Login" from the dropdown
3. Enter admin credentials:
   - Email: `admin@example.com`
   - Password: (the password you set in PocketBase)

### Login as Student

1. Open the app
2. Select "Student Login" from the dropdown
3. Enter student credentials:
   - Email: `student@example.com`
   - Password: (the password you set in PocketBase)

## Features Implemented

✅ **Environment-based Configuration**

- Automatic dev/prod URL switching
- Configurable collection names

✅ **Dual Authentication**

- Admin login (admins collection)
- Student login (users collection)

✅ **Token Management**

- Automatic token storage
- Token validation and refresh
- Secure logout

✅ **Error Handling**

- Network error handling
- User-friendly error messages
- Loading states

✅ **Session Management**

- Persistent login sessions
- Automatic token validation
- Role-based access control

## Testing

Run the tests to ensure everything is working:

```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Connection Refused**: Make sure PocketBase is running on `http://127.0.0.1:8090`

2. **Invalid Credentials**: Check your email/password in PocketBase admin dashboard

3. **Collection Not Found**: Ensure you created the `admins` and `users` collections

4. **CORS Issues**: PocketBase should handle CORS automatically, but check browser console for errors

### Debug Mode

To see detailed logs, run your app with:

```bash
flutter run --debug
```

## Next Steps

1. **Update Production URL**: Replace the placeholder URL with your actual PocketBase instance
2. **Add More Collections**: Create additional collections for students, assessments, etc.
3. **Implement CRUD Operations**: Add services for managing data
4. **Add More User Roles**: Extend the role system as needed
5. **Add Data Validation**: Implement form validation and data constraints

## Security Notes

- Never commit real credentials to version control
- Use environment variables for sensitive configuration
- Implement proper authentication checks in your UI
- Use HTTPS in production environments
