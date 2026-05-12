import SwiftUI

struct FavoriteSongsView: View {

    let songs: [Song]

    var body: some View {

        ZStack {

            AnimatedBackgroundView()

            ScrollView {

                VStack(spacing: 16) {

                    ForEach(songs) { song in

                        SongCard(song: song)
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
}
