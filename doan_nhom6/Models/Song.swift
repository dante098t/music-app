import Foundation

struct Song: Identifiable, Codable, Equatable {

    let id: Int64

       let title: String

       let image_url: String?

       let audio_url: String?

       let album_id: Int64?

       let artist_id: Int64?

       let duration: Int?

       let genre: String?

       let lyrics: String?

       let play_count: Int?

       let created_at: String?

       let is_premium: Bool?

       let status: String?

       let is_explicit: Bool?

       let artist: Artist?
}

struct SongInsert: Encodable {

    let title: String
    let image_url: String
    let audio_url: String

    let genre: String
    let lyrics: String

    let artist_id: String

    let is_premium: Bool
    let is_explicit: Bool

    let status: String
}
