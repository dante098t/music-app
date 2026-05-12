import Foundation
import Combine

final class FavoriteManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    

    static let shared =
    FavoriteManager()

    // MARK: Favorites

    @Published var songs:
    [Song] = []

    // MARK: Storage Key

    private let key =
    "favorite_songs"

    // MARK: Init

    private init() {
        // Load persisted favorites without using self before init completes
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode([Song].self, from: data) {
                self.songs = decoded
            }
        }
    }

    // MARK: Toggle Favorite

    func toggle(
        _ song: Song
    ) {

        if isFavorite(song) {

            remove(song)

        } else {

            add(song)
        }

        save()
    }

    // MARK: Add

    func add(
        _ song: Song
    ) {

        guard !songs.contains(
            where: {
                $0.id == song.id
            }
        ) else {
            return
        }

        songs.insert(
            song,
            at: 0
        )

        save()
    }

    // MARK: Remove

    func remove(
        _ song: Song
    ) {

        songs.removeAll {
            $0.id == song.id
        }

        save()
    }

    // MARK: Check

    func isFavorite(
        _ song: Song
    ) -> Bool {

        songs.contains {
            $0.id == song.id
        }
    }

    // MARK: Save

    private func save() {

        do {

            let data =
            try JSONEncoder()
                .encode(songs)

            UserDefaults.standard.set(
                data,
                forKey: key
            )

        } catch {

            print(
                "Save favorite error:",
                error
            )
        }
    }
}
