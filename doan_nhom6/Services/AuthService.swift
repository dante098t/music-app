import Foundation
import Supabase

final class AuthService {

    static let shared = AuthService()

    private init() {}

    private var client: SupabaseClient {
        SupabaseService.shared.client
    }

    // MARK: - Register

    func register(
        email: String,
        password: String,
        username: String,
        role: String
    ) async throws {

        let response = try await client.auth.signUp(
            email: email,
            password: password
        )

        let user = response.user

        try await client
            .from("profiles")
            .insert([
                "id": user.id.uuidString,
                "email": email,
                "username": username,
                "role": role
            ])
            .execute()
    }

    // MARK: - Login

    func login(
        email: String,
        password: String
    ) async throws {

        try await client.auth.signIn(
            email: email,
            password: password
        )
    }

    // MARK: - Logout

    func logout() async throws {

        try await client.auth.signOut()
    }

    // MARK: - Current User Role

    func fetchRole() async throws -> String {

        let session = try await client.auth.session

        struct Profile: Decodable {

            let role: String
        }

        let profile: Profile = try await client
            .from("profiles")
            .select("role")
            .eq("id", value: session.user.id)
            .single()
            .execute()
            .value

        return profile.role
    }
}
