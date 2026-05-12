import SwiftUI

struct LoginView: View {
    let onLoginSuccess: () -> Void
    @State private var email = ""
    @State private var password = ""

    @State private var errorMessage = ""

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [.black, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {

                    Spacer()

                    Text("Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Group {

                        TextField("Email", text: $email)

                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .foregroundColor(.white)

                    Button {

                        Task {

                            await login()
                        }

                    } label: {

                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
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

    func login() async {

        do {

            try await AuthService.shared.login(
                email: email,
                password: password
            )

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}

