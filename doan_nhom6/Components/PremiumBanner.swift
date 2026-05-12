import SwiftUI

struct PremiumBanner: View {

    @State private var showPremium = false

    var body: some View {

        ZStack {

            // MARK: Banner
            ZStack(alignment: .leading) {

                LinearGradient(
                    colors: [
                        .purple,
                        .pink,
                        .red.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(alignment: .leading, spacing: 14) {

                    Text("Premium Access")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text("Listen without ads and unlock offline mode.")
                        .foregroundColor(.white.opacity(0.9))

                    Button {

                        withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                            showPremium = true
                        }

                    } label: {

                        Text("Upgrade Now")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(24)
            }
            .frame(height: 190)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: .pink.opacity(0.4), radius: 20)
            .blur(radius: showPremium ? 6 : 0)
            .scaleEffect(showPremium ? 0.95 : 1)

            // MARK: Premium Screen Overlay
            if showPremium {
                PremiumView(isPresented: $showPremium)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)
            }
        }
    }
}
