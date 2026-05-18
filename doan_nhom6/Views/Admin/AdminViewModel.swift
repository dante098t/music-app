import Foundation
import SwiftUI
import Supabase
import Combine

@MainActor
final class AdminViewModel: ObservableObject {

    // MARK: - DASHBOARD
    @Published var totalUsers = 0
    @Published var premiumUsers = 0
    @Published var totalSongs = 0
    @Published var pendingSongs = 0
    @Published var totalReports = 0
    @Published var revenue: Double = 0

    // MARK: - DATA
    @Published var songs: [Song] = []
    @Published var pendingSongsList: [Song] = []
    @Published var reports: [Report] = []
    @Published var artists: [Artist] = []
    @Published var users: [Profile] = []

    // MARK: - LOADING
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let client = SupabaseService.shared.client

    init() {
        Task {
            await loadAll()
        }
    }

    func loadAll() async {
        await fetchDashboard()
        await fetchSongs()
        await fetchPendingSongs()
        await fetchReports()
        await fetchArtists()
        await fetchUsers()
    }

    // MARK: - DASHBOARD
    func fetchDashboard() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let usersCount = fetchUsersCount()
            async let premiumCount = fetchPremiumUsersCount()
            async let songsCount = fetchSongsCount()
            async let pendingCount = fetchPendingSongsCount()
            async let reportsCount = fetchReportsCount()
            async let totalRevenue = fetchRevenue()

            (totalUsers, premiumUsers, totalSongs, pendingSongs, totalReports, revenue) =
                try await (usersCount, premiumCount, songsCount, pendingCount, reportsCount, totalRevenue)

            print("✅ Dashboard Loaded")
        } catch {
            print("❌ Dashboard Error:", error)
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - COUNTS
    private func fetchUsersCount() async throws -> Int {
        let response = try await client
            .from("profiles")
            .select("*", count: .exact)
            .execute()
        return response.count ?? 0
    }

    private func fetchPremiumUsersCount() async throws -> Int {
        let response = try await client
            .from("profiles")
            .select("*", count: .exact)
            .eq("premium", value: true)
            .execute()
        return response.count ?? 0
    }

    private func fetchSongsCount() async throws -> Int {
        let response = try await client
            .from("songs")
            .select("*", count: .exact)
            .execute()
        return response.count ?? 0
    }

    private func fetchPendingSongsCount() async throws -> Int {
        let response = try await client
            .from("songs")
            .select("*", count: .exact)
            .eq("status", value: "pending")
            .execute()
        return response.count ?? 0
    }

    private func fetchReportsCount() async throws -> Int {
        let response = try await client
            .from("reports")
            .select("*", count: .exact)
            .execute()
        return response.count ?? 0
    }

    private func fetchRevenue() async throws -> Double {
        let response: [Subscription] = try await client
            .from("subscriptions")
            .select("price")
            .eq("status", value: "active")           // Nên filter theo status thay vì chỉ premium
            .execute()
            .value
        
        return response.reduce(0) { $0 + ($1.price ?? 0) }
    }

    // MARK: - SONGS
    func fetchSongs() async {
        do {
            let response: [Song] = try await client
                .from("songs")
                .select("""
                    *,
                    artist:artists(*)
                """)
                .order("created_at", ascending: false)
                .execute()
                .value

            songs = response
            print("✅ Songs Loaded: \(response.count)")
        } catch {
            print("❌ Fetch Songs Error:", error)
        }
    }

    func fetchPendingSongs() async {
        do {
            let response: [Song] = try await client
                .from("songs")
                .select("""
                    *,
                    artist:artists(*)
                """)
                .eq("status", value: "pending")
                .order("created_at", ascending: false)
                .execute()
                .value

            pendingSongsList = response
            print("✅ Pending Songs: \(response.count)")
        } catch {
            print("❌ Pending Songs Error:", error)
        }
    }

    // MARK: - SONG ACTIONS
    func approveSong(_ song: Song) async {
        do {
            try await client
                .from("songs")
                .update(["status": "approved"])
                .eq("id", value: String(song.id))                    // Int64
                .execute()

            await fetchPendingSongs()
            await fetchSongs()
            print("✅ Song Approved")
        } catch {
            print("❌ Approve Song Error:", error)
        }
    }

    func rejectSong(_ song: Song) async {
        do {
            try await client
                .from("songs")
                .update(["status": "rejected"])
                .eq("id", value: String(song.id)) 
                .execute()

            await fetchPendingSongs()
            print("❌ Song Rejected")
        } catch {
            print("❌ Reject Song Error:", error)
        }
    }

    func deleteSong(_ song: Song) async {
        do {
            try await client
                .from("songs")
                .delete()
                .eq("id", value: String(song.id))
                .execute()

            songs.removeAll { $0.id == song.id }
            print("🗑 Song Deleted")
        } catch {
            print("❌ Delete Song Error:", error)
        }
    }

    // MARK: - REPORTS
    func fetchReports() async {
        do {
            let response: [Report] = try await client
                .from("reports")
                .select("""
                    *,
                    profile:profiles(*),
                    song:songs(*)
                """)
                .order("created_at", ascending: false)
                .execute()
                .value

            reports = response
            print("✅ Reports Loaded: \(response.count)")
        } catch {
            print("❌ Reports Error:", error)
        }
    }

    func resolveReport(_ report: Report) async {
        do {
            try await client
                .from("reports")
                .update(["status": "resolved"])
                .eq("id", value: report.id)                 // UUID
                .execute()

            await fetchReports()
            print("✅ Report Resolved")
        } catch {
            print("❌ Resolve Report Error:", error)
        }
    }

    // MARK: - ARTISTS
    func fetchArtists() async {
        do {
            let response: [Artist] = try await client
                .from("artists")
                .select("*")
                .order("monthly_listeners", ascending: false)
                .execute()
                .value

            artists = response
            print("✅ Artists Loaded: \(response.count)")
        } catch {
            print("❌ Artists Error:", error)
        }
    }

    func verifyArtist(_ artist: Artist) async {
        do {
            try await client
                .from("artists")
                .update(["verified": true])
                .eq("id", value: String(artist.id))
                .execute()

            await fetchArtists()
            print("✅ Artist Verified")
        } catch {
            print("❌ Verify Artist Error:", error)
        }
    }

    // MARK: - USERS
    func fetchUsers() async {
        do {
            let response: [Profile] = try await client
                .from("profiles")
                .select("*")
                .order("created_at", ascending: false)
                .execute()
                .value

            users = response
            print("✅ Users Loaded: \(response.count)")
        } catch {
            print("❌ Users Error:", error)
        }
    }

    func banUser(_ user: Profile) async {
        do {
            try await client
                .from("profiles")
                .update(["is_banned": true])
                .eq("id", value: user.id)                   // UUID
                .execute()

            await fetchUsers()
            print("🚫 User Banned")
        } catch {
            print("❌ Ban User Error:", error)
        }
    }

    func givePremium(_ user: Profile) async {
        do {
            try await client
                .from("profiles")
                .update(["premium": true])
                .eq("id", value: user.id)
                .execute()

            await fetchUsers()
            print("💎 Premium Granted")
        } catch {
            print("❌ Give Premium Error:", error)
        }
    }

    func removePremium(_ user: Profile) async {
        do {
            try await client
                .from("profiles")
                .update(["premium": false])
                .eq("id", value: user.id)
                .execute()

            await fetchUsers()
            print("❌ Premium Removed")
        } catch {
            print("❌ Remove Premium Error:", error)
        }
    }
}
