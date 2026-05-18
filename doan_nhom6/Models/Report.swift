import Foundation

struct Report: Codable, Identifiable {

    let id: UUID

    let user_id: UUID?

    let song_id: Int64?

    let reason: String?

    let description: String?

    let status: String?

    let created_at: String?

    let song: Song?
}
