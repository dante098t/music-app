import Foundation

import Combine

import Supabase

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var songs: [Song] = []
    @Published var albums: [Album] = []
    
    @Published var favoriteSongs: [Song] = []
    @Published var savedAlbums: [Album] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    // MARK: SONGS
    func fetchSongs() async {
        
        isLoading = true
        errorMessage = nil
        
        defer {
            
            isLoading = false
        }
        
        do {
            
            let response: [Song] = try await client
            
                .from("songs")
            
                .select("""
                
                    id,
                    title,
                    image_url,
                    audio_url,
                    album_id,
                    artist_id,
                    duration,
                    genre,
                    lyrics,
                    play_count,
                    created_at,
                    is_premium,
                    status,
                    is_explicit,
                
                    artist:artists(
                        id,
                        name,
                        avatar_url,
                        bio,
                        verified,
                        monthly_listeners,
                        cover_url
                    ),
                
                    album:albums(
                        id,
                        title,
                        cover_url,
                        artist_id
                    )
                
                """)
            
                .order(
                    "created_at",
                    ascending: false
                )
            
                .execute()
            
                .value
            
            self.songs = response
            
            print("🎵 SONGS LOADED:", response.count)
            
            for song in response {
                
                print("""
                
                -------------------------
                🎵 TITLE: \(song.title ?? "")
                🎧 GENRE: \(song.genre ?? "NO GENRE")
                👤 ARTIST: \(song.artist?.name ?? "NO ARTIST")
                💎 PREMIUM: \(song.is_premium ?? false)
                🔞 EXPLICIT: \(song.is_explicit ?? false)
                📀 STATUS: \(song.status ?? "unknown")
                -------------------------
                
                """)
            }
            
        } catch {
            
            self.errorMessage =
            error.localizedDescription
            
            print("❌ SONG ERROR:", error)
        }
    }
    
    // MARK: ALBUMS
    func fetchAlbums() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Album] = try await client
                .from("albums")
                .select("""
                    *,
                    artist:artists (
                        id,
                        name,
                        avatar_url
                    )
                """)
                .order("title", ascending: true)
                .execute()
                .value
            
            self.albums = response
            print("💿 ALBUMS LOADED:", response.count)
            
            // Debug
            for album in response {
                print("Album: \(album.title) → Artist: \(album.artist?.name ?? "NIL")")
            }
            
        } catch {
            print("❌ Fetch albums error:", error)
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
