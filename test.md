flowchart TD

subgraph group_app["App Shell"]
  node_app_entry["App Entry<br/>SwiftUI app"]
  node_content_view["Content View<br/>root view<br/>[ContentView.swift]"]
  node_root_view["Root View<br/>navigation shell<br/>[RootView.swift]"]
end

subgraph group_ui["SwiftUI Screens"]
  node_auth_views["Auth Flow<br/>login/register screens<br/>[LoginView.swift]"]
  node_home_views["Home Browse<br/>browse screens<br/>[HomeView.swift]"]
  node_player_views["Player Suite<br/>playback screens<br/>[PlayerView.swift]"]
  node_profile_view["Profile View<br/>account screen<br/>[ProfileView.swift]"]
  node_premium_views["Premium UI<br/>entitlement screens<br/>[PremiumView.swift]"]
  node_admin_view["Admin View<br/>moderation console<br/>[AdminView.swift]"]
  node_artist_dashboard["Artist Dashboard<br/>creator console"]
  node_components["Shared Components<br/>ui building blocks<br/>[AlbumCard.swift]"]
end

subgraph group_state["State Layer"]
  node_app_state(("App State<br/>session manager<br/>[AppState.swift]"))
  node_auth_vm(("Auth VM<br/>view model"))
  node_home_vm(("Home VM<br/>view model"))
  node_player_vm(("Player VM<br/>view model"))
  node_song_vm(("Song VM<br/>view model"))
  node_side_menu_vm(("Menu VM<br/>view model"))
  node_admin_vm(("Admin VM<br/>view model"))
end

subgraph group_domain["Domain Models"]
  node_song_model["Song<br/>music entity<br/>[Song.swift]"]
  node_music_models["Music Library<br/>album/artist/playlist<br/>[Album.swift]"]
  node_user_models["User Profile<br/>account/subscription<br/>[Profile.swift]"]
  node_library_models["Library Data<br/>personalization"]
  node_ops_models["Ops Data<br/>admin/analytics<br/>[Report.swift]"]
end

subgraph group_infra["Services"]
  node_supabase_service[("Supabase<br/>backend gateway")]
  node_auth_service["Auth Service<br/>authentication<br/>[AuthService.swift]"]
  node_music_services["Music Services<br/>catalog services<br/>[SongService.swift]"]
  node_player_service["Audio Player<br/>playback engine"]
  node_library_services["Library Services<br/>personalization services"]
  node_storage_service["Storage Service<br/>asset storage"]
  node_analytics_service["Analytics Service<br/>reporting"]
  node_core_data[("Local Store<br/>Core Data<br/>[Persistence.swift]")]
end

node_app_entry -->|"launches"| node_content_view
node_content_view -->|"hosts"| node_root_view
node_root_view -->|"reads session"| node_app_state
node_root_view -->|"routes auth"| node_auth_views
node_root_view -->|"routes listener"| node_home_views
node_root_view -->|"routes premium"| node_premium_views
node_root_view -->|"routes artist"| node_artist_dashboard
node_root_view -->|"routes admin"| node_admin_view
node_home_views -->|"binds"| node_home_vm
node_auth_views -->|"binds"| node_auth_vm
node_player_views -->|"binds"| node_player_vm
node_player_views -->|"uses"| node_song_vm
node_home_views -->|"uses"| node_side_menu_vm
node_admin_view -->|"binds"| node_admin_vm
node_player_views -->|"plays through"| node_player_service
node_player_service -->|"loads tracks"| node_music_services
node_auth_vm -->|"authenticates"| node_auth_service
node_home_vm -->|"browses catalog"| node_music_services
node_song_vm -->|"queries songs"| node_music_services
node_library_services -->|"persists"| node_core_data
node_music_services -->|"queries backend"| node_supabase_service
node_auth_service -->|"auth backend"| node_supabase_service
node_storage_service -->|"stores assets"| node_supabase_service
node_analytics_service -->|"reports data"| node_supabase_service
node_music_services -->|"fetches media"| node_storage_service
node_player_views -->|"shows history"| node_library_services
node_admin_view -->|"reports"| node_analytics_service
node_premium_views -->|"checks entitlement"| node_user_models
node_home_views -->|"composes"| node_components
node_player_views -->|"composes"| node_components

click node_app_entry "https://github.com/dante098t/music-app/blob/main/doan_nhom6/doan_nhom6App.swift"
click node_content_view "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ContentView.swift"
click node_root_view "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/RootView.swift"
click node_auth_views "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Auth /LoginView.swift"
click node_home_views "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Home/HomeView.swift"
click node_player_views "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Player/PlayerView.swift"
click node_profile_view "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Profile/ProfileView.swift"
click node_premium_views "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/User Premium/PremiumView.swift"
click node_admin_view "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Admin/AdminView.swift"
click node_artist_dashboard "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Artist /ArtistDashboardView.swift"
click node_components "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Components/AlbumCard.swift"
click node_app_state "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Managers/AppState.swift"
click node_auth_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/AuthViewModel.swift"
click node_home_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/HomeViewModel.swift"
click node_player_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/PlayerViewModel.swift"
click node_song_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/SongViewModel.swift"
click node_side_menu_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/ViewModels/SideMenuViewModel.swift"
click node_admin_vm "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Views/Admin/AdminViewModel.swift"
click node_song_model "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/Song.swift"
click node_music_models "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/Album.swift"
click node_user_models "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/Profile.swift"
click node_library_models "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/FavoriteAlbum.swift"
click node_ops_models "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Models/Report.swift"
click node_supabase_service "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/SupabaseService.swift"
click node_auth_service "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AuthService.swift"
click node_music_services "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/SongService.swift"
click node_player_service "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AudioPlayerService.swift"
click node_library_services "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/FavoriteManager.swift"
click node_storage_service "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/StorageService.swift"
click node_analytics_service "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Services/AnalyticsService.swift"
click node_core_data "https://github.com/dante098t/music-app/blob/main/doan_nhom6/Persistence.swift"

classDef toneNeutral fill:#f8fafc,stroke:#334155,stroke-width:1.5px,color:#0f172a
classDef toneBlue fill:#dbeafe,stroke:#2563eb,stroke-width:1.5px,color:#172554
classDef toneAmber fill:#fef3c7,stroke:#d97706,stroke-width:1.5px,color:#78350f
classDef toneMint fill:#dcfce7,stroke:#16a34a,stroke-width:1.5px,color:#14532d
classDef toneRose fill:#ffe4e6,stroke:#e11d48,stroke-width:1.5px,color:#881337
classDef toneIndigo fill:#e0e7ff,stroke:#4f46e5,stroke-width:1.5px,color:#312e81
classDef toneTeal fill:#ccfbf1,stroke:#0f766e,stroke-width:1.5px,color:#134e4a
class node_app_entry,node_content_view,node_root_view toneBlue
class node_auth_views,node_home_views,node_player_views,node_profile_view,node_premium_views,node_admin_view,node_artist_dashboard,node_components toneAmber
class node_app_state,node_auth_vm,node_home_vm,node_player_vm,node_song_vm,node_side_menu_vm,node_admin_vm toneMint
class node_song_model,node_music_models,node_user_models,node_library_models,node_ops_models toneRose
class node_supabase_service,node_auth_service,node_music_services,node_player_service,node_library_services,node_storage_service,node_analytics_service,node_core_data toneIndigo
