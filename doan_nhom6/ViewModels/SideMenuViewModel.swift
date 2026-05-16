import Foundation
import Supabase
import Combine

@MainActor
final class SideMenuViewModel: ObservableObject {
    @Published var favoriteSongs: [Song] = []
    @Published var savedAlbums: [Album] = []

    private let client = SupabaseService.shared.client

    func fetchSavedAlbums() async {

        guard let userId = client.auth.currentUser?.id else {
            print("❌ USER NIL")
            return
        }

        do {

            let favorites: [FavoriteAlbum] = try await client
                .from("favorite_albums")
                .select("*")
                .eq("user_id", value: userId)
                .execute()
                .value

            print("📦 FAVORITES:", favorites.count)

            let ids = favorites.map { $0.album_id }

            let albums: [Album] = try await client

                           .from("albums")

                           .select("""

                               *,

                               artist:artists (

                                   id,

                                   name,

                                   avatar_url

                               )

                           """)

                           .in("id", values: ids)

                           .execute()

                           .value

            print("💿 SAVED ALBUMS:", albums.count)

            self.savedAlbums = albums

        } catch {
            print("❌ FETCH ERROR:", error)
        }
    }
    func fetchFavoriteSongs() async {

            guard let userId = client.auth.currentUser?.id else {

                print("❌ USER NIL")

                return

            }

            do {

                let favorites: [Favorite] = try await client

                    .from("favorites")

                    .select("*")

                    .eq("user_id", value: userId)

                    .execute()

                    .value


                let ids: [Int] = favorites.map { Int($0.song_id) }
                let songs: [Song] = try await client

                    .from("songs")

                    .select("""

                        *,

                        artist:artists (

                            id,

                            name,

                            avatar_url

                        )

                    """)

                    .in("id", values: ids)

                    .execute()

                    .value

                await MainActor.run {

                    self.favoriteSongs = songs

                }

                print("❤️ FAVORITE SONGS:", songs.count)

            } catch {

                print("❌ FAVORITE FETCH ERROR:", error)

            }

        }



    }


