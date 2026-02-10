# Local Testing Guide

## Prerequisites
- Node.js installed
- Both client and server dependencies installed

## Step-by-Step Testing Process

### 1. Start the Backend Server
```bash
cd server
npm run dev
```
**Expected Output:** Server should start on port 10000
**Test URL:** http://localhost:10000/api/public/tutors/search

### 2. Start the Frontend Client
```bash
cd client  
npm run dev
```
**Expected Output:** Client should start on port 3000
**Test URL:** http://localhost:3000

### 3. Verify Database Connection
Test this endpoint to ensure data is loading:
```
GET http://localhost:10000/api/public/tutors/search
```

### 4. Test Frontend-Backend Communication
1. Open browser to http://localhost:3000
2. Navigate to tutors page
3. Check browser Network tab - all requests should go to `localhost:10000`

## Troubleshooting

### If requests still go to production URL:
1. Clear browser cache
2. Restart both servers
3. Check browser dev tools > Application > Local Storage (clear if needed)

### If database returns null:
1. Verify DATABASE_URL in server/.env
2. Check if Neon database is accessible
3. Run: `cd server && npm run seed` (if needed)

### If port 10000 doesn't work:
1. Check if another process is using port 10000
2. Kill the process: `netstat -ano | findstr :10000`
3. Then: `taskkill /PID <PID_NUMBER> /F`

## Environment Variables Check
- Client `.env`: NEXT_PUBLIC_API_URL should be "http://localhost:10000"
- Server `.env`: PORT should be 10000, NODE_ENV should be 'development'

## Success Indicators
✅ Server starts without errors on port 10000
✅ Client starts without errors on port 3000  
✅ API endpoint returns data (not null)
✅ Frontend makes requests to localhost:10000 (not production URL)
✅ No 503 errors in browser console