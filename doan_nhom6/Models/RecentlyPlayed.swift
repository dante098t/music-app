import Foundation

struct RecentlyPlayed: Codable, Identifiable {

    let id: UUID

    let user_id: UUID

    let song_id: Int

    let played_at: String?

    let song: Song?
}
