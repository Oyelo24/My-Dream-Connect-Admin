# Production Setup Guide

## Overview
This guide helps you deploy the MDC Admin Panel to production with PocketBase backend.

## Environment Configuration

1. **Copy environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Update .env file with your production values:**
   ```env
   # PocketBase URLs
   POCKETBASE_DEV_URL=http://127.0.0.1:8090
   POCKETBASE_PROD_URL=https://your-production-pocketbase.com

   # App Configuration
   APP_NAME=Your App Name
   APP_SUBTITLE=Admin Panel
   APP_INITIALS=YA

   # Collection Names (match your PocketBase collections)
   ADMIN_COLLECTION=admins
   USER_COLLECTION=users
   STUDENT_COLLECTION=students
   ATTENDANCE_COLLECTION=attendance
   ASSESSMENT_COLLECTION=assessments
   ANALYTICS_COLLECTION=analytics

   # Feature Flags
   ENABLE_ANALYTICS=true
   ENABLE_BULK_OPERATIONS=true
   ENABLE_EXPORT=true
   ```

## PocketBase Setup

### Required Collections

1. **admins** - Admin users
   - email (email, required)
   - password (password, required)
   - name (text, required)
   - role (select: admin)

2. **users** - Students/regular users
   - id (text, auto-generated in format: MDC-YYYY-C####)
   - email (email, required)
   - password (password, required)
   - name (text, required)
   - phone (text)
   - enrollmentDate (date)
   - lastSeen (datetime)
   - attendance (text, default: "0%")
   - grade (text, default: "N/A")
   - status (select: ACTIVE, INACTIVE, HOLD)
   - progress (text, default: "0/0")
   - avatar (file, optional)

3. **attendance** - Attendance records
   - studentId (text, format: MDC-YYYY-C####)
   - studentName (text)
   - studentEmail (email)
   - session (text)
   - checkInTime (text)
   - status (select: present, late, absent, excused)
   - override (text, optional)
   - notes (text)
   - date (date)

4. **assessments** - Assessment data
   - title (text, required)
   - subject (text, required)
   - duration (text)
   - questions (text)
   - status (select: active, completed, draft, scheduled)
   - completion (text, default: "0/0")
   - performance (text)
   - createdDate (datetime)
   - description (text, optional)
   - totalQuestions (number, default: 0)
   - totalStudents (number, default: 0)

5. **analytics** - Analytics data (optional)
   - metric (text)
   - value (json)
   - date (date)

## Deployment Steps

### 1. Build for Production
```bash
flutter build web --release
```

### 2. Deploy to Web Server
Upload the `build/web` folder to your web server.

### 3. Configure PocketBase
- Deploy PocketBase to your server
- Create the required collections
- Set up authentication rules
- Configure CORS for your domain

### 4. Update Environment
- Ensure `.env` file has correct production URLs
- Test all API endpoints

## Security Considerations

1. **Authentication:**
   - Use strong passwords for admin accounts
   - Enable 2FA if available in PocketBase
   - Regularly rotate API keys

2. **Data Protection:**
   - Use HTTPS for all communications
   - Implement proper CORS policies
   - Regular database backups

3. **Access Control:**
   - Implement role-based permissions
   - Audit user access regularly
   - Monitor for suspicious activities

## Monitoring

1. **Health Checks:**
   - Monitor PocketBase server status
   - Check API response times
   - Monitor error rates

2. **Data Integrity:**
   - Regular database backups
   - Data validation checks
   - Audit logs

## Troubleshooting

### Common Issues:

1. **Connection Errors:**
   - Check PocketBase URL in .env
   - Verify CORS settings
   - Check network connectivity

2. **Authentication Issues:**
   - Verify collection names match .env
   - Check user permissions
   - Validate token expiration

3. **Data Loading Issues:**
   - Check collection schemas
   - Verify API endpoints
   - Monitor server logs

## Support

For issues and support:
1. Check PocketBase documentation
2. Review Flutter web deployment guides
3. Check application logs for errors