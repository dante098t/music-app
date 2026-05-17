import SwiftUI

struct RecentlyPlayedView: View {

    let songs: [Song]

    var body: some View {

        ZStack {

            AnimatedBackgroundView()

            LinearGradient(
                colors: [
                    .black.opacity(0.7),
                    .clear,
                    .black.opacity(0.85)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    Text("Recently Played")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    VStack(spacing: 16) {

                        ForEach(songs) { song in

                            NavigationLink {
                                PlayerRouterView(
                                    song: song,
                                    songs: songs
                                )

                            } label: {

                                SongCard(song: song)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
    }
}
