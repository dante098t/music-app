import SwiftUI
import Supabase
import Auth

struct RootView: View {

    @State private var isLoggedIn = false
    @State private var role: UserRole = .user
    @State private var isLoading = true

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

        // 👇 chỉ gọi 1 lần
        .onAppear {

            Task {

                await checkSession()
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

            // CHECK SESSION

            let session = try await SupabaseService
                .shared
                .client
                .auth
                .session

            print("Logged in:", session.user.email ?? "")

            // FETCH ROLE

            let roleString = try await AuthService
                .shared
                .fetchRole()

            // CONVERT STRING -> ENUM

            role = UserRole(rawValue: roleString) ?? .user

            // SUCCESS

            isLoggedIn = true

        } catch {

            print("Session error:", error)

            isLoggedIn = false
        }
    }
}
