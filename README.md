# TECHNICAL PROJECT REPORT: MOBILE MUSIC STREAMING PLATFORM
**Course/Project:** Final Graduation Project - Group 6 (doan_nhom6)  
**Academic Field:** Computer Science & Artificial Intelligence  
**Platform:** iOS (Swift, SwiftUI, AVFoundation)  
**Backend Infrastructure:** Supabase 

---

## ABSTRACT
This report presents the design, architectural implementation, and development of a cloud-native, high-performance mobile music streaming application for iOS. Engineered using Swift and SwiftUI, the platform addresses modern streaming challenges by incorporating local caching (Core Data) and low-level hardware decoding (AVFoundation). The backend utilizes a Serverless BaaS architecture through Supabase and PostgreSQL, supporting granular role-based access controls for Standards users, Premium subscribers, Artists, and Administrators.

---

## 1. INTRODUCTION & OBJECTIVES

### 1.1 Problem Statement
Modern media streaming systems demand high scalability, seamless audio delivery over fluctuating networks, secure digital rights management (Premium content locks), and multi-role operations (content creators, consumer users, and platform administrators).

### 1.2 Project Objectives
* **High-fidelity Playback:** Implement a non-blocking audio pipeline using native iOS frameworks.
* **Architecture Integrity:** Utilize the MVVM-Service design pattern to decouple UI presentation from complex business logic.
* **Role-Based Operations:** Build functional sub-systems for Premium subscription management and comprehensive Administrator governance.
* **Offline Resiliency:** Support localized persistence for user interactive traits (favorites, history) without data-link requirements.

---

## 2. SYSTEM ARCHITECTURE & COMPONENT MAPPING

The application is engineered using a scalable **MVVM-Service (Model-View-ViewModel-Service)** architecture. UI rendering, business logic, persistence, and remote cloud infrastructure are cleanly decoupled into distinct structural layers:

### 2.1 App Shell & Initialization
* **[doan_nhom6App.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/doan_nhom6App.swift)**: The main bootstrap entry point of the iOS application.
* **[ContentView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ContentView.swift)**: The primary shell container view hosting the navigation flow.
* **[RootView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/RootView.swift)**: The central router configuration managing view transitions based on session state.
* **[AppState.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Managers/AppState.swift)**: Manages global reactive session states and active player events.

### 2.2 Presentation Layer (SwiftUI Views)
* **[LoginView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Auth%20/LoginView.swift)**: Handles identity management and credential authorization.
* **[HomeView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Home/HomeView.swift)**: The main exploratory layout streaming personalized data cards.
* **[PlayerView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Player/PlayerView.swift)**: Implements UI structures for playback control and timelines.
* **[PremiumView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/User%20Premium/PremiumView.swift)**: Dedicated portal handling monetization and premium access packages.
* **[AdminView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Admin/AdminView.swift)**: Dashboard UI designed for catalog and user moderation tasks.
* **[ArtistDashboardView.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Artist%20/ArtistDashboardView.swift)**: The creator layout presenting listening charts and track ingestion pipelines.
* **[AlbumCard.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Components/AlbumCard.swift)**: Reusable UI component designed for layout decoupling.

### 2.3 Logic Layer (View Models)
* **[AuthViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/AuthViewModel.swift)**: Binds credential inputs to backend authentication clients.
* **[HomeViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/HomeViewModel.swift)**: Processes dynamic data mapping for home segments.
* **[PlayerViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/PlayerViewModel.swift)**: Exposes streaming controllers directly to playback layout controls.
* **[SongViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/SongViewModel.swift)**: Maps track structural data to functional view models.
* **[SideMenuViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/SideMenuViewModel.swift)**: Controls drawer layouts and secondary application options.
* **[AdminViewModel.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Admin/AdminViewModel.swift)**: Manages network state manipulation for system configurations.

### 2.4 Domain & Storage Layer
* **[Song.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/Song.swift)**: Concrete data entity structures matching database tables.
* **[Persistence.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Persistence.swift)**: Standard Core Data stack initialization wrapper handling local database records.

### 2.5 Core Services & Infrastructure
* **[AuthService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AuthService.swift) & [AuthManager.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AuthManager.swift)**: Manages communication logs and validation with identity provider directories.
* **[SupabaseService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/SupabaseService.swift)**: Low-level client communications gateway acting as the network engine.
* **[SongService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/SongService.swift)**: Pulls relative album collections and structural track configurations.
* **[AudioPlayerService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AudioPlayerService.swift)**: High-performance controller wrapping Apple's **AVFoundation** engine.
* **[StorageService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/StorageService.swift)**: Handles image assets and audio streaming asset buckets.
* **[AnalyticsService.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AnalyticsService.swift)**: Processes tracking reports evaluating metric charts.
* **[FavoriteManager.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/FavoriteManager.swift) & [RecentlyPlayedManager.swift](https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/RecentlyPlayedManager.swift)**: Synchronizes in-memory interaction caches directly into Core Data database structures.

---

## 3. TECHNICAL SPECIFICATIONS & IMPLEMENTATION

### 3.1 Technology Stack & Rationale
* **SwiftUI & Combine:** Employed for declarative UI declaration. State tracking utilizes `ObservableObject` and custom Combine publishers to synchronize real-time timeline data across views without re-rendering overheads.
* **AVFoundation (`AVPlayer`):** Utilized for hardware-accelerated audio streaming, handling network audio buffers, and supporting metadata queries.
* **Core Data:** Serves as the local persistent storage layer (`Persistence.swift`), minimizing network reliance by handling local favorites caching and history tracking.
* **Supabase & PostgreSQL backend:** Acts as the decentralized cloud database gateway executing secure JWT authorization mechanisms, secure bucket storage configurations, and relational structured querying (**PostgreSQL** instance).

---

## 4. SYSTEM FEATURES & BUSINESS LOGIC

### 4.1 Client Presentation Layer
* **Audio Engine Control:** Implements seamless Play/Pause workflows, track skips, scrub-seeking, volume management, custom track looping, and shuffle operations.
* **Playlist & Discovery Engine:** Empowers user-driven curation, offering public vs private configuration layers, album exploration sub-interfaces, and detailed verified artist dashboards (with monthly listener analytics).
* **Identity Protection:** Implements native secure authentication screens (`LoginView.swift`, Register, Reset tokens) processing transactional updates directly to cloud directory nodes.

### 4.2 Core Administration & Creator Subsystems
* **Granular Role Rights (RBAC):** Restricts high-fidelity tracks to Verified Premium tiers.
* **Administrative Console (`AdminView.swift`):** Provides platform data control via full CRUD pipelines for media files, genre mappings, and explicit content restriction switches.
* **Platform Governance & BI:** Includes workflows for threat protection logs (user banning/reports) alongside analytical widgets evaluating transactional platform metrics and revenue charts.

---

## 5. EXPERIMENTAL RESULTS & DEPLOYMENT

### 5.1 System Prerequisite
* **Client Host Environment:** iOS 16.0+ SDK execution target.
* **IDE Development Layer:** Xcode 15.0+ compiler.
* **Programming Runtime:** Swift 5.9 native compilation suite.

### 5.2 Deployment Instructions

1. **Clone the Source Tree:**
```bash
   git clone [https://github.com/dante098t/music-app.git](https://github.com/dante098t/music-app.git)
   cd music-app/doan_nhom6
