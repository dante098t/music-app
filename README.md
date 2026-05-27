#  Music Streaming App

A modern iOS music streaming application built with SwiftUI and Supabase.

The app supports music playback, playlists, albums, artists, premium subscriptions, admin dashboard, favorites, and more.

---

#  Features

##  Authentication

- Login
- Register
- Forgot Password
- Logout

---

##  Music Player

- Play / Pause
- Next / Previous
- Seek Audio
- Volume Control
- Shuffle
- Repeat
- Queue System
- Recommended Songs

---

##  Favorites

- Favorite Songs
- Save Albums
- Recently Played

---

##  Albums

- Browse Albums
- Album Details
- Album Songs

---

##  Artists

- Artist Profile
- Verified Artists
- Monthly Listeners
- Artist Songs
- Artist Albums

---

##  Playlist System

- Create Playlist
- Add Songs to Playlist
- Public / Private Playlist

---

##  Premium System

- Premium Subscription
- Premium Songs
- Subscription Management

---

##  Admin Dashboard

Admin can:

- Add Songs
- Edit Songs
- Delete Songs
- Upload Audio
- Upload Images
- Set Genres
- Set Explicit Content
- Manage Featured Artists
- Approve Artist Songs
- View User Reports
- Ban Users
- Grant Premium Access
- Revenue Analytics

---

#  Tech Stack

| Technology | Purpose |
|---|---|
| SwiftUI | iOS UI Framework |
| Supabase | Backend & Authentication |
| PostgreSQL | Database |
| AVFoundation | Audio Playback |
| MVVM | App Architecture |
| Combine | State Management |

---

#  Architecture

The application follows the MVVM architecture:

```text
View → ViewModel → Model → Supabase
