import SwiftUI

struct AlbumCard: View {

    let album: Album

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            AsyncImage(
                url: URL(
                    string: album.cover_url ?? ""
                )
            ) { phase in

                switch phase {

                case .success(let image):

                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()

                default:

                    ZStack {

                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(
                            Color.white.opacity(0.08)
                        )

                        ProgressView()
                    }
                }
            }
            .frame(width: 160, height: 160)

            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(album.title)

                    .font(.headline)

                    .foregroundColor(.white)

                    .lineLimit(1)

                Text(
                    album.artist?.name
                    ?? "Unknown Artist"
                )

                .font(.subheadline)

                .foregroundColor(.gray)

                .lineLimit(1)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)

        .padding(10)

        .background(.ultraThinMaterial)

        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }
}
