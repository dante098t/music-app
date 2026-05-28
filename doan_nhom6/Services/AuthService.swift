import Foundation
import Supabase

// MARK: - PROFILE INSERT MODEL
struct ProfileInsert: Encodable {
    let id: String
    let username: String
    let role: String
    let premium: Bool
    let is_banned: Bool
    let avatar_url: String?
}

// MARK: - AUTH SERVICE
final class AuthService {

    static let shared = AuthService()

    private init() {}

    private var client: SupabaseClient {
        SupabaseService.shared.client
    }

    // MARK: - REGISTER
    func register(
        email: String,
        password: String,
        username: String,
        role: String
    ) async throws {

        do {

            // 1. SIGN UP
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )

            let userId = response.user.id

            print("✅ AUTH CREATED:", userId)

            // 2. CREATE PROFILE MODEL
            let data = ProfileInsert(
                id: userId.uuidString,
                username: username,
                role: role,
                premium: false,
                is_banned: false,
                avatar_url: nil
            )

            // 3. INSERT PROFILE
            try await client
                .from("profiles")
                .insert(data)
                .execute()

            print("✅ PROFILE CREATED SUCCESS")

        } catch {
            print("❌ REGISTER ERROR:", error)
            throw error
        }
    }

    // MARK: - LOGIN (FIXED)
    func login(
        email: String,
        password: String
    ) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
        print("✅ LOGIN SUCCESS")
    }

    // MARK: - LOGOUT
    func logout() async throws {

        try await client.auth.signOut()

        print("✅ LOGOUT SUCCESS")
    }
    func updatePassword(password: String) async throws {

        try await SupabaseService
            .shared
            .client
            .auth
            .update(
                user: UserAttributes(
                    password: password
                )
            )

        print("✅ Password updated")
    }
    // MARK: - FORGOT PASSWORD
   func resetPassword(email: String) async throws {

       try await client.auth.resetPasswordForEmail(
        email,

               redirectTo: URL(string: "musicapp://reset-password")
       )

       print("✅ RESET PASSWORD EMAIL SENT")
   }
    // MARK: - FETCH ROLE
    func fetchRole() async -> UserRole {

        guard let userId =
                client.auth.currentUser?.id.uuidString
        else {

            return .user
        }

        do {

            let response: [Profile] = try await client
                .from("profiles")
                .select("*")
                .eq("id", value: userId)
                .execute()
                .value

            return response.first?.role ?? .user

        } catch {

            print("❌ FETCH ROLE ERROR:", error)

            return .user
        }
    }
}

