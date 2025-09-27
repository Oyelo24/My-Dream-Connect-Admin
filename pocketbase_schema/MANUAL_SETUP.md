# PocketBase Manual Setup Guide

PocketBase doesn't support JSON import. Create collections manually in the admin dashboard.

## 1. Users Collection (Auth)

**Collection Type:** Auth
**Collection Name:** users

**Fields:**
- `firstName` - Text (required, min: 2, max: 50)
- `lastName` - Text (required, min: 2, max: 50)  
- `role` - Select (required, values: admin, student)

**Auth Options:**
- ✅ Allow email auth
- ❌ Allow username auth
- Min password length: 8
- ✅ Require email

## 2. Students Collection (Base)

**Collection Type:** Base
**Collection Name:** students

**Fields:**
- `studentId` - Text (required, pattern: ^STU[0-9]{6}$)
- `firstName` - Text (required, min: 2, max: 50)
- `lastName` - Text (required, min: 2, max: 50)
- `email` - Email (required)
- `phone` - Text (required, min: 10, max: 15)
- `status` - Select (required, values: active, inactive, graduated)

## 3. Tracks Collection (Base)

**Collection Type:** Base
**Collection Name:** tracks

**Fields:**
- `trackName` - Text (required, min: 3, max: 100)
- `description` - Text (required, max: 500)
- `credits` - Number (required, min: 1, max: 6)
- `status` - Select (required, values: active, inactive)

## 4. Assessments Collection (Base)

**Collection Type:** Base
**Collection Name:** assessments

**Fields:**
- `title` - Text (required, min: 3, max: 100)
- `description` - Text (required, max: 500)
- `trackId` - Relation (required, collection: tracks, max: 1)
- `type` - Select (required, values: quiz, exam, assignment, project)
- `totalMarks` - Number (required, min: 1, max: 100)
- `dueDate` - Date (required)
- `status` - Select (required, values: draft, published, completed)

## 5. Grades Collection (Base)

**Collection Type:** Base
**Collection Name:** grades

**Fields:**
- `studentId` - Relation (required, collection: students, max: 1)
- `assessmentId` - Relation (required, collection: assessments, max: 1)
- `marksObtained` - Number (required, min: 0)
- `totalMarks` - Number (required, min: 1)
- `percentage` - Number (optional, min: 0, max: 100)
- `grade` - Select (optional, values: A, B, C, D, F)

## Steps:

1. Open PocketBase admin dashboard
2. Go to "Collections" 
3. Click "New collection"
4. Follow the field definitions above
5. Create collections in this order: users → tracks → students → assessments → grades

## API Rules (Optional):

Set these in the "API rules" tab for each collection:
- **List/View:** `@request.auth.id != ""`
- **Create/Update/Delete:** `@request.auth.role = "admin"`