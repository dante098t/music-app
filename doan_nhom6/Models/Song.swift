import Foundation

struct Song: Identifiable, Codable, Equatable {

    let id: Int64
    let title: String
    let image_url: String?
    let audio_url: String

    let album_id: Int64
    let artist_id: Int64

    // JOIN OBJECT
    let artist: Artist?
    let album: Album?
}
