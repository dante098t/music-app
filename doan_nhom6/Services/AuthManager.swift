import Foundation
import Supabase
import Combine

@MainActor
final class AuthManager: ObservableObject {
    
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
   
    @Published var currentUser: Supabase.User?
    private let client = SupabaseService.shared.client
    
    private init() {
        checkAuthStatus()
    }
    @Published var role: UserRole = .user

       

       var isAdmin: Bool {

           role == .admin

       }

       

       var isArtist: Bool {

           role == .artist

       }

       

       var isPremium: Bool {

           role == .premium

       }

       

       var isUser: Bool {

           role == .user

       }
    
    
    func checkAuthStatus() {
        Task {
            do {
                // Cách mới đúng nhất theo Supabase Swift SDK
                let session = try await client.auth.session
                
                self.currentUser = session.user
                self.isAuthenticated = true
                
            } catch {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await client.auth.signOut()
                
                self.isAuthenticated = false
                self.currentUser = nil
                
                
                print("✅ Đã đăng xuất thành công")
                
            } catch {
                print("❌ Sign out error:", error)
            }
        }
    }
}
