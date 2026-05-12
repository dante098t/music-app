import SwiftUI
import Supabase
import Auth

struct RootView: View {

    @State private var isLoggedIn = false

    @State private var role = ""

    @State private var isLoading = true

    var body: some View {

        NavigationStack {

            Group {

                if isLoading {

                    ZStack {

                        Color.black
                            .ignoresSafeArea()

                        ProgressView()
                            .tint(.white)
                    }

                } else if isLoggedIn {

                    switch role {

                    case "admin":

                        AdminView()

                    
                    default:

                        HomeView()
                    }

                } else {

                    LoginView {

                        Task {

                            await checkSession()
                        }
                    }
                }
            }
        }
        .task {

            await checkSession()
        }
    }

    func checkSession() async {

        isLoading = true

        defer {

            isLoading = false
        }

        do {

            let session =
            try await SupabaseService
                .shared
                .client
                .auth
                .session

            print(session.user.email ?? "")

            role =
            try await AuthService
                .shared
                .fetchRole()

            isLoggedIn = true

        } catch {

            isLoggedIn = false
        }
    }
}
