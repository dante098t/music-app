import Foundation

struct Profile: Codable, Identifiable {

    let id: String
    let userId:UUID
    let name: String
    let email: String?
    let role: String
    let premium:Bool
    let is_banned:Bool
}
