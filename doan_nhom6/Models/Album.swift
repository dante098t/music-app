import Foundation

struct Album: Identifiable, Codable, Equatable {

    let id: Int64
    let title: String
    let cover_url: String?
    let artist_id: Int64

    var artist: Artist?
}
