# WeatherAppAssignment

A native iOS weather application built using **SwiftUI** and **MVVM architecture**.  
The app allows users to search weather by US city or fetch weather using their current location.

This project was built as a clean, production-style implementation with a focus on:
- Correct functionality
- Clear separation of concerns
- Defensive error handling
- Testability
- Maintainable architecture

---

## Features

- Search weather by US city
- Fetch weather using current location (CoreLocation)
- OpenWeather API integration
- Weather icons with built-in image caching
- Auto-load last searched city on app launch
- Graceful handling of denied location permissions
- Dark mode support
- Accessibility-friendly UI
- Unit tests using XCTest

---

## Architecture

The app follows **MVVM (Model–View–ViewModel)**.

### View (SwiftUI)
- Responsible only for rendering UI and handling user interactions
- No business logic or networking code
- Observes state from the ViewModel

### ViewModel
- Holds UI state
- Handles user actions
- Coordinates between services
- Written to be fully testable

### Services
- **WeatherService** – Fetches weather data from OpenWeather API
- **LocationService** – Handles CoreLocation permission and location updates
- **PersistenceService** – Stores the last searched city

All services are injected via **protocols** to support mocking and unit testing.

---

## Persistence Strategy

- `UserDefaults` is used to store the last searched city
- This choice was intentional to avoid unnecessary complexity
- Core Data was not used because the data is small, simple, and non-relational

---

## Image Caching

- Weather icons are loaded using `AsyncImage`
- iOS automatically handles memory and disk caching via `URLCache`
- No custom image cache was required for this use case

---

## Location Handling

- The app requests location permission only after explicit user action
- Permission states are handled gracefully:
  - Authorized → fetch weather for current location
  - Denied / Restricted → show fallback UI and allow manual city search
- Location failures do not crash the app

---

## Error Handling

The app defensively handles:
- Invalid or empty city input
- Network failures
- API errors
- Location permission denial
- Missing or unavailable location data

User-friendly messages are displayed instead of raw errors.

---

## Testing

### Unit Tests
- Written using **XCTest**
- Focused on the **ViewModel**
- External dependencies (network, location, persistence) are mocked
- Tests are fast, deterministic, and isolated

### What Is Tested
- Successful city search
- Failed city search
- Location permission denial
- Location-based weather fetch
- Auto-loading last searched city

---

## Build & Run

1. Clone the repository
2. Open `WeatherAppAssignment.xcodeproj`
3. Select an iOS Simulator or physical device
4. Run the app (`Cmd + R`)
5. Run tests (`Cmd + U`)

---

## Notes

- API key is embedded for demo purposes only
- In a production app, API keys should be secured via a backend or encrypted configuration
- UI design is intentionally simple to prioritize functionality and architecture

---
