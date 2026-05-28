import SwiftUI

struct ResetPasswordView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var newPassword = ""
    @State private var confirmPassword = ""

    @State private var message = ""
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

                Text("Create New Password")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.white)

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.white)

                Button {

                    Task {
                        await updatePassword()
                    }

                } label: {

                    ZStack {

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 56)

                        if isLoading {

                            ProgressView()

                        } else {

                            Text("Update Password")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }

                if !message.isEmpty {

                    Text(message)
                        .foregroundColor(.green)
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

    func updatePassword() async {

        guard newPassword == confirmPassword else {

            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = ""
        message = ""

        do {

            try await AuthService.shared.updatePassword(
                password: newPassword
            )

            message = "Password updated successfully."

        } catch {

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
