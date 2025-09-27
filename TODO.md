# Remove Student Login Options - Admin Only

## Plan Implementation Steps:

### 1. Update Login Screen (`lib/screens/login_screen.dart`)
- [ ] Remove commented-out user type selection dropdown
- [ ] Remove `_selectedUserType` variable and related methods
- [ ] Update button text to always show "Access Admin Dashboard"
- [ ] Update signup button text to be admin-focused
- [ ] Remove conditional logic based on user type

### 2. Update AuthViewModel (`lib/viewmodels/auth_viewmodel.dart`)
- [ ] Change default `_userType` from 'users' to 'admins'
- [ ] Update `setUserType()` method to default to 'admins'

### 3. Update AuthService (`lib/services/auth_service.dart`)
- [ ] Change default collection from 'users' to 'admins'
- [ ] Update `initializeAuth()` method to default to 'admins'

### 4. Update ConfigService (`lib/services/config_service.dart`)
- [ ] Change `_defaultCollection` from 'users' to 'admins'

## Testing Steps:
- [ ] Verify changes compile correctly
- [ ] Test admin login functionality
- [ ] Confirm no student login options remain in UI
