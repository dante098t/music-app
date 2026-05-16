import Foundation
import SwiftUI
import Supabase
import Combine

struct Favorite: Codable, Identifiable {
    let id: UUID
    let user_id: UUID
    let song_id: Int64
    let created_at: String?
}

struct FavoriteInsert: Encodable {
    let user_id: String
    let song_id: Int64
}

final class FavoriteManager: ObservableObject {

    static let shared = FavoriteManager()

    @Published var favoriteSongs: [Song] = []

    private let client = SupabaseService.shared.client

    private init() {}

    func isFavorite(_ song: Song) -> Bool {
        favoriteSongs.contains { $0.id == song.id }
    }
    func toggle(_ song: Song) {

        if isFavorite(song) {

            print("💔 REMOVE FAVORITE")

            remove(song)

        } else {

            print("❤️ ADD FAVORITE")

            add(song)

        }

    }

    func add(_ song: Song) {

        guard let userId = client.auth.currentUser?.id else { return }

        let songId = song.id

        Task {
            do {
                try await client
                    .from("favorites")
                    .insert(
                        FavoriteInsert(
                            user_id: userId.uuidString,
                            song_id: songId
                        )
                    )
                    .execute()

                await MainActor.run {
                    self.favoriteSongs.append(song)
                }

            } catch {
                print("ADD FAVORITE ERROR:", error)
            }
        }
        print("🚀 SENDING FAVORITE TO SUPABASE")
        print("USER:", userId.uuidString)
        print("SONG:", songId)
    }

    func remove(_ song: Song) {

        guard let userId = client.auth.currentUser?.id else { return }

        let songId = song.id

        Task {
            do {
                try await client
                    .from("favorites")
                    .delete()
                    .eq("user_id", value: userId.uuidString)
                    .eq("song_id", value: Int(songId) ?? String(songId))
                    .execute()

                await MainActor.run {
                    self.favoriteSongs.removeAll { $0.id == song.id }
                }

            } catch {
                print("REMOVE FAVORITE ERROR:", error)
            }
        }
        print("🗑 REMOVE FAVORITE FROM SUPABASE")
        print("USER:", userId.uuidString)
        print("SONG:", songId)
    }

    func fetchFavorites(allSongs: [Song]) async {

        guard let userId = client.auth.currentUser?.id else { return }

        do {
            let response: [Favorite] = try await client
                .from("favorites")
                .select("*")
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value

            let ids = Set(response.map { $0.song_id })

            let songs = allSongs.filter { song in
                ids.contains(song.id)
            }

            await MainActor.run {
                self.favoriteSongs = songs
            }

        } catch {
            print("FETCH FAVORITES ERROR:", error)
        }
    }
}

