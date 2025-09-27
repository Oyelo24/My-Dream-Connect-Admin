# PocketBase Schema Import Guide

These JSON files can be imported directly into your PocketBase admin dashboard.

## How to Import:

1. **Start PocketBase** and open the admin dashboard
2. **Go to Collections** in the sidebar
3. **Click "Import collections"** button
4. **Select and upload** each JSON file one by one
5. **Review the schema** before confirming import

## Import Order (Important):

Import in this order to handle dependencies:

1. **users.json** (auth collection - no dependencies)
2. **courses.json** (base collection - no dependencies)
3. **students.json** (depends on users)
4. **assessments.json** (depends on courses)
5. **attendance.json** (depends on students, courses)
6. **grades.json** (depends on students, assessments, courses)
7. **schedules.json** (depends on courses)
8. **reports.json** (depends on users)
9. **settings.json** (depends on users)

## Key Features:

- **Role-based access control** (admin/student)
- **Automatic timestamps** (created/updated)
- **File uploads** for profile images
- **Validation patterns** for emails, phone numbers, IDs
- **Unique constraints** to prevent duplicates
- **Cascade delete** for related records
- **Proper indexing** for performance

## Access Rules:

- **Admin**: Full CRUD access to all collections
- **Student**: Read-only access to their own data
- **Public**: No access (authentication required)

## Post-Import Setup:

1. Create an admin user account
2. Set up default settings records
3. Configure email settings if needed
4. Test the API endpoints with your Flutter app

## API Usage:

Use PocketBase SDK in your Flutter app:
```dart
final pb = PocketBase('http://127.0.0.1:8090');
```