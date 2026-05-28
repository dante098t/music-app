import SwiftUI

struct ForgotPasswordView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
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

                Text("Reset Password")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                TextField("Enter your email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.white)

                Button {

                    Task {
                        await resetPassword()
                    }

                } label: {

                    ZStack {

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 56)

                        if isLoading {

                            ProgressView()

                        } else {

                            Text("Send Reset Email")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }

                if !message.isEmpty {

                    Text(message)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                }

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

    // MARK: RESET PASSWORD
    func resetPassword() async {

        errorMessage = ""
        message = ""
        isLoading = true

        do {

            try await AuthService.shared.resetPassword(
                email: email
            )

            message = "Password reset email sent."

        } catch {

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
