import SwiftUI

struct AlbumDetailView: View {

    let album: Album
    let songs: [Song]
    @State private var isFavorite = false
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

                image
                    .resizable()
                    .scaledToFill()
                    .clipped()

            } placeholder: {

                RoundedRectangle(cornerRadius: 30)

                    .fill(Color.white.opacity(0.08))

                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 320)

            .clipShape(
                RoundedRectangle(
                    cornerRadius: 34
                )
            )

            .shadow(
                color: .black.opacity(0.35),
                radius: 20,
                y: 10
            )

            VStack(
                alignment: .leading,
                spacing: 10
            ) {

                // MARK: TITLE

                Text(album.title)

                    .font(.largeTitle.bold())

                    .foregroundColor(.white)

                // MARK: ARTIST

                Text(
                    album.artist?.name
                    ?? "Unknown Artist"
                )

                .font(.title3)

                .foregroundColor(.gray)

                // MARK: SONG COUNT + ACTIONS

                HStack(spacing: 14) {

                    Text("\(songs.count) Songs")

                        .font(.subheadline)

                        .foregroundColor(
                            .white.opacity(0.7)
                        )

                    Spacer()

                    // MARK: FAVORITE

                    Button {

                        let id = Int(album.id)

                        print("🔥 TOGGLE FAVORITE ALBUM:", id)

                        Task {
                            await FavoriteAlbumService.shared.toggle(albumId: id)

                            let newState = await FavoriteAlbumService.shared.isFavorite(albumId: id)

                            print("✅ NEW FAVORITE STATE:", newState)

                            await MainActor.run {
                                isFavorite = newState
                            }
                        }

                    } label: {

                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                    
                    }.task {
                        
                        let id = Int(album.id)

                        print("🔍 CHECK FAVORITE ALBUM ID:", id)

                        let result = await FavoriteAlbumService.shared.isFavorite(albumId: id)

                        print("❤️ IS FAVORITE RESULT:", result)

                        isFavorite = result

                    }


                    // MARK: MENU

                    Menu {

                        Button {

                            // TODO:
                            // add album to queue

                        } label: {

                            Label(
                                "Add to Queue",
                                systemImage:
                                    "text.badge.plus"
                            )
                        }

                        Button(
                            role: .destructive
                        ) {

                            // TODO:
                            // report album

                        } label: {

                            Label(
                                "Report",
                                systemImage:
                                    "exclamationmark.bubble"
                            )
                        }

                    } label: {

                        Image(
                            systemName:
                                "ellipsis"
                        )

                        .rotationEffect(
                            .degrees(90)
                        )

                        .font(.system(size: 18))

                        .foregroundColor(.white)

                        .frame(
                            width: 42,
                            height: 42
                        )

                        .background(
                            .ultraThinMaterial
                        )

                        .clipShape(Circle())
                    }
                }
                .padding(.top, 4)
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
    
