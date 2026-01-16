# Movie Watchlist App

A beautiful cross-platform mobile app built with Flutter to save and manage movies you want to watch later. Available for both iOS and Android.

## Features

- 👤 **User Authentication** - Register, login, and manage user accounts
- 🔍 **Search Movies from OMDb** - Search and add movies from Open Movie Database (includes data from IMDB)
- 🎬 **Movie Posters** - Beautiful movie posters displayed in your watchlist
- ✅ Add movies with title, year, genre, rating, and description
- 📱 Beautiful, modern Material Design 3 UI
- 🌓 Dark mode support
- 🔍 Filter movies by status (All, To Watch, Watched)
- ✅ Mark movies as watched/unwatched
- 💾 Local storage using SharedPreferences (user-specific data)
- 🗑️ Delete movies from your watchlist
- 👤 User profile with editable username
- 📱 Responsive design for all screen sizes

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- iOS Simulator / Android Emulator or physical device
- **OMDb API Key** (free) - See [OMDB_API_SETUP.md](OMDB_API_SETUP.md) for instructions

### Installation

1. Clone or navigate to this project directory
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. **Set up OMDb API Key** (required for movie search):
   - Get a free API key from http://www.omdbapi.com/apikey.aspx
   - Open `lib/services/omdb_service.dart`
   - Replace `YOUR_OMDB_API_KEY_HERE` with your API key
   - See [OMDB_API_SETUP.md](OMDB_API_SETUP.md) for detailed instructions

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk
# or for app bundle
flutter build appbundle
```

**iOS:**
```bash
flutter build ios
```

## Project Structure

```
lib/
├── main.dart                      # App entry point with auth wrapper
├── models/
│   ├── movie.dart                 # Movie data model
│   ├── omdb_movie.dart           # OMDb API movie model
│   └── user.dart                  # User model
├── services/
│   ├── storage_service.dart      # Local storage service (user-specific)
│   ├── omdb_service.dart          # OMDb API service
│   └── auth_service.dart          # Authentication service
├── screens/
│   ├── login_screen.dart          # Login screen
│   ├── register_screen.dart        # Registration screen
│   ├── movie_list_screen.dart    # Main screen with movie list
│   ├── movie_search_screen.dart  # Movie search screen
│   └── profile_screen.dart        # User profile screen
└── widgets/
    ├── movie_card.dart           # Movie card widget
    ├── add_movie_dialog.dart     # Add movie dialog
    └── movie_search_result_card.dart # Search result card
```

## Technologies Used

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **SharedPreferences** - Local data persistence
- **Material Design 3** - Modern UI components
- **OMDb API** - Movie database (Open Movie Database / IMDB)
- **HTTP** - Network requests
- **Cached Network Image** - Image loading and caching

## License

This project is open source and available for personal use.
