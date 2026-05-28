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

                // MARK: Background

                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {

                    Spacer()

                    // MARK: Logo

                    Image(systemName: "music.note.house.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text("Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Text("Login to continue")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 30)

                    // MARK: Form

                    VStack(spacing: 18) {

                        // Email

                        HStack {

                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white.opacity(0.7))

                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Password

                        HStack {

                            Image(systemName: "lock.fill")
                                .foregroundColor(.white.opacity(0.7))

                            SecureField("Password", text: $password)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Forgot Password

                        HStack {

                            Spacer()

                            NavigationLink {

                                ForgotPasswordView()

                            } label: {

                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }

                    .padding(.horizontal)

                    // MARK: Error Message

                    if !errorMessage.isEmpty {

                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    // MARK: Login Button

                    Button {

                        Task {
                            await login()
                        }

                    } label: {

                        ZStack {

                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white)
                                .frame(height: 58)

                            if isLoading {

                                ProgressView()

                            } else {

                                Text("Login")
                                    .font(.headline.bold())
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .disabled(isLoading)

                    // MARK: Register

                    HStack {

                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))

                        NavigationLink {

                            RegisterView()

                        } label: {

                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 22)

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

#Preview {

    LoginView {

    }
}
