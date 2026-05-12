import Foundation
import Combine

final class RecentlyPlayedManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    

    static let shared = RecentlyPlayedManager()

    @Published var songs: [Song] = []

    private let key = "recently_played_songs"

    private init() {
        // Initialize from persisted data if available
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoded = try JSONDecoder().decode([Song].self, from: data)
                self.songs = decoded
            } catch {
                print(error.localizedDescription)
                self.songs = []
            }
        } else {
            self.songs = []
        }
    }

    // MARK: Add Song

    func add(_ song: Song) {

        // Remove duplicate

        songs.removeAll {
            $0.id == song.id
        }

        // Insert to top

        songs.insert(song, at: 0)

        // Limit history

        if songs.count > 50 {

            songs.removeLast()
        }

        save()
    }

    // MARK: Save

    private func save() {

        do {

            let data = try JSONEncoder().encode(songs)

            UserDefaults.standard.set(
                data,
                forKey: key
            )

        } catch {

            print(error.localizedDescription)
        }
    }
}
