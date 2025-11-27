# Backend Connection Setup

Your Flutter app is now connected to the Airline1 backend! Follow these steps to complete the setup:

## 1. Update Backend URL

Open `lib/services/api_client.dart` and update the `baseUrl` constant:

```dart
static const String baseUrl = "http://YOUR_BACKEND_URL/api";
```

### For Different Environments:

- **Android Emulator**: Use `http://10.0.2.2:5000/api` (localhost maps to host machine)
- **iOS Simulator**: Use `http://localhost:5000/api`
- **Physical Device**: Use your computer's IP address, e.g., `http://192.168.1.100:5000/api`
- **Production**: Use your deployed backend URL

## 2. Install Dependencies

Run this command in the `ticketing_flutter` directory:

```bash
flutter pub get
```

## 3. Start Your Backend

Make sure your Airline1 backend is running:

1. Navigate to `Ticketing-Airlines-Backend/Airline1`
2. Run: `dotnet run`
3. The backend should start on `https://localhost:5000` or `http://localhost:5000`

## 4. Configure CORS (if needed)

If you encounter CORS errors, update your backend's `Program.cs` to allow requests from your Flutter app:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp",
        policy =>
        {
            policy.WithOrigins("http://localhost", "http://10.0.2.2")
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

// In the app configuration:
app.UseCors("AllowFlutterApp");
```

## 5. Test the Connection

1. Run your Flutter app
2. Try to register a new user
3. Try to login with existing credentials
4. Search for flights

## API Endpoints Used

- `POST /api/auth/login` - User login
- `POST /api/users/register` - User registration
- `GET /api/flights` - Get all flights
- `GET /api/flights/{id}` - Get flight by ID
- `GET /api/flightprices/flight/{flightId}` - Get flight prices

## Authentication

The app automatically stores JWT tokens using `shared_preferences`. Tokens are included in all authenticated requests via the `Authorization: Bearer {token}` header.

## Troubleshooting

- **Connection refused**: Check that the backend is running and the URL is correct
- **CORS errors**: Add CORS configuration to your backend
- **401 Unauthorized**: Check that JWT tokens are being saved correctly
- **404 Not Found**: Verify the API endpoints match your backend routes
