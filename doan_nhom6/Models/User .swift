import Foundation

struct User: Codable, Identifiable {

    let id: UUID

    let username: String

    let email: String

    let role: String

    let avatarURL: String?

    let createdAt: String

    enum CodingKeys: String, CodingKey {

        case id
        case username
        case email
        case role

        case avatarURL = "avatar_url"

        case createdAt = "created_at"
    }
}
