import SwiftUI
import Supabase
import Auth

struct RootView: View {

    @State private var isLoggedIn = false
    @State private var role: UserRole = .user
    @State private var isLoading = true

    // RESET PASSWORD FLOW

    @State private var showResetPassword = false

    var body: some View {

        NavigationStack {

            Group {

                // MARK: LOADING

                if isLoading {

                    ZStack {

                        Color.black
                            .ignoresSafeArea()

                        ProgressView()
                            .tint(.white)
                    }
                }

                // MARK: RESET PASSWORD

                else if showResetPassword {

                    ResetPasswordView()
                }

                // MARK: AUTHENTICATED

                else if isLoggedIn {

                    switch role {

                    case .admin:

                        AdminView()

                    case .artist:

                        ArtistDashboardView()

                    case .premium:

                        PremiumHomeView()

                    case .user:

                        HomeView()
                    }
                }

                // MARK: LOGIN

                else {

                    LoginView {

                        Task {

                            await checkSession()
                        }
                    }
                }
            }
        }

        // MARK: APP OPEN

        .onAppear {

            print("🚀 RootView appeared")

            Task {

                await checkSession()
            }
        }

        // MARK: DEEP LINK

        .onOpenURL { url in

            print("🔥 OPEN URL:")
            print(url.absoluteString)

            // RESET PASSWORD LINK

            if url.absoluteString.contains("reset-password") {

                print("✅ Reset password link detected")

                showResetPassword = true
            }
        }
    }
}

// MARK: - SESSION

extension RootView {

    @MainActor
    func checkSession() async {

        isLoading = true

        defer {

            isLoading = false
        }

        do {

            print("🔍 Checking session...")

            // GET SESSION

            let session = try await SupabaseService
                .shared
                .client
                .auth
                .session

            print("✅ Session found")
            print("📧 EMAIL:", session.user.email ?? "NO EMAIL")
            print("🆔 USER ID:", session.user.id)

            // FETCH ROLE

            let fetchedRole = await AuthService
                .shared
                .fetchRole()

            print("🎭 ROLE:", fetchedRole.rawValue)

            // SAVE ROLE

            role = fetchedRole

            // LOGIN SUCCESS

            isLoggedIn = true

            print("✅ User logged in")

        } catch {

            print("❌ Session error:")
            print(error.localizedDescription)

            isLoggedIn = false
        }
    }
}
