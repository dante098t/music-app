import Foundation
import Supabase

struct FavoriteAlbumInsert: Encodable {
    let user_id: UUID
    let album_id: Int
}

final class FavoriteAlbumService {

    static let shared = FavoriteAlbumService()
    private init() {}

    private let client = SupabaseService.shared.client

    // MARK: CHECK
    func isFavorite(albumId: Int) async -> Bool {

        guard let userId = client.auth.currentUser?.id else {
            return false
        }

        do {
            let response: [FavoriteAlbum] = try await client
                .from("favorite_albums")
                .select("*")
                .eq("user_id", value: userId)
                .eq("album_id", value: albumId)
                .execute()
                .value

            return !response.isEmpty

        } catch {
            print("CHECK ERROR:", error)
            return false
        }
    }

    // MARK: TOGGLE
    func toggle(albumId: Int) async {

        guard let userId = client.auth.currentUser?.id else {
            return
        }

        do {

            let response: [FavoriteAlbum] = try await client
                .from("favorite_albums")
                .select("*")
                .eq("user_id", value: userId)
                .eq("album_id", value: albumId)
                .execute()
                .value

            if let existing = response.first {

                try await client
                    .from("favorite_albums")
                    .delete()
                    .eq("id", value: existing.id)
                    .execute()

            } else {

                try await client
                    .from("favorite_albums")
                    .insert(
                        FavoriteAlbumInsert(
                            user_id: userId,
                            album_id: albumId
                        )
                    )
                    .execute()
            }

        } catch {
            print("TOGGLE ERROR:", error)
        }
    }
}
