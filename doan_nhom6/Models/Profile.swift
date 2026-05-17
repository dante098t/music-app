import Foundation

struct Profile: Codable, Identifiable {

    let id: String

    let username: String?

    let email: String?

    let role: UserRole

    let premium: Bool

    let is_banned: Bool

}
