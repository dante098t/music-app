import SwiftUI

struct FavoriteSongsView: View {

    @StateObject private var favoriteManager =
    FavoriteManager.shared

    var body: some View {

        ZStack {

            AnimatedBackgroundView()

            LinearGradient(
                colors: [
                    .black.opacity(0.75),
                    .clear,
                    .black.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if favoriteManager.favoriteSongs.isEmpty {

                emptyState

            } else {

                ScrollView(
                    showsIndicators: false
                ) {

                    LazyVStack(
                        spacing: 16
                    ) {

                        ForEach(
                            favoriteManager.favoriteSongs
                        ) { song in

                            NavigationLink {

                                PlayerView(
                                    song: song,
                                    songs:
                                    favoriteManager.favoriteSongs
                                )

                            } label: {

                                SongCard(song: song)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .padding(.bottom, 30)
                }
            }
        }

        .navigationTitle("Favorite Songs")

        .navigationBarTitleDisplayMode(.inline)

        .preferredColorScheme(.dark)

        .onAppear {

            print("❤️ FAVORITE SONGS VIEW APPEAR")

            print(
                "❤️ TOTAL FAVORITES:",
                favoriteManager.favoriteSongs.count
            )

            for song in favoriteManager.favoriteSongs {

                print(
                    "🎵 FAVORITE:",
                    song.title ?? "Unknown"
                )
            }
        }
    }
}

// MARK: EMPTY

extension FavoriteSongsView {

    var emptyState: some View {

        VStack(spacing: 18) {

            Image(systemName: "heart.slash")

                .font(.system(size: 52))

                .foregroundColor(.gray)

            Text("No Favorite Songs")

                .font(.title3.bold())

                .foregroundColor(.white)

            Text(
                "Songs you like will appear here."
            )
            .foregroundColor(.gray)
        }
    }
}
