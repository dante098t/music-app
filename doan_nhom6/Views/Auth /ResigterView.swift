import SwiftUI

struct RegisterView: View {

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    @State private var selectedRole = "free_user"

    let roles = [
        "free_user",
        "premium_user",
        "artist"
    ]

    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [.black, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {

                Spacer()

                Text("Create Account")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Group {

                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $password)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .foregroundColor(.white)

                Picker("Role", selection: $selectedRole) {

                    ForEach(roles, id: \.self) { role in

                        Text(role)
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)

                Button {

                    Task {

                        await register()
                    }

                } label: {

                    ZStack {

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 56)

                        if isLoading {

                            ProgressView()

                        } else {

                            Text("Create Account")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                .disabled(isLoading)

                if !errorMessage.isEmpty {

                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
        }
    }

    // MARK: - Register

    func register() async {

        errorMessage = ""

        if username.isEmpty ||
            email.isEmpty ||
            password.isEmpty {

            errorMessage = "Please fill all fields"
            return
        }

        if password.count < 6 {

            errorMessage = "Password must be at least 6 characters"
            return
        }

        isLoading = true

        do {

            try await AuthService.shared.register(
                email: email,
                password: password,
                username: username,
                role: selectedRole
            )

        } catch {

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {

    RegisterView()
}
