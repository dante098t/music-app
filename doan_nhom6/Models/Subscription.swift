import Foundation

struct Subscription: Codable {

    let id: UUID

    let user_id: String?

    let premium: Bool?

    let expires_at: String?

    let price: Double?
}
