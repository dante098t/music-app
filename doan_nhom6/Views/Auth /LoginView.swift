import SwiftUI

struct LoginView: View {

    let onLoginSuccess: () -> Void

    @State private var email = ""
    @State private var password = ""

    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [.black, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 22) {

                    Spacer()

                    Text("Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    VStack(spacing: 16) {

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)

                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.white)

                    Button {

                        Task {
                            await login()
                        }

                    } label: {

                        ZStack {

                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(height: 56)

                            if isLoading {

                                ProgressView()

                            } else {

                                Text("Login")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    NavigationLink {

                        RegisterView()

                    } label: {

                        Text("Create Account")
                            .foregroundColor(.gray)
                    }

                    if !errorMessage.isEmpty {

                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }

    // MARK: LOGIN

    func login() async {

        errorMessage = ""
        isLoading = true

        do {

            try await AuthService.shared.login(
                email: email,
                password: password
            )

            onLoginSuccess()

        } catch {

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
