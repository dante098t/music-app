import SwiftUI

struct AlbumDetailView: View {

    let album: Album
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

                VStack(alignment: .leading, spacing: 28) {

                    albumHeader

                    songsSection
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
    }
}
extension AlbumDetailView {
    
    var albumHeader: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            AsyncImage(
                url: URL(string: album.cover_url ?? "")
            ) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(0.08))
                    .overlay { ProgressView() }
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 34))
            .shadow(color: .black.opacity(0.35), radius: 20, y: 10)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(album.title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text(album.artist?.name ?? "Unknown Artist")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text("\(songs.count) Songs")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    var songsSection: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("Tracks")
                .font(.title2.bold())
                .foregroundColor(.white)

            VStack(spacing: 16) {

                ForEach(songs) { song in

                    NavigationLink {

                        PlayerView(song: song, songs: songs)

                    } label: {

                        SongCard(song: song)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
    
