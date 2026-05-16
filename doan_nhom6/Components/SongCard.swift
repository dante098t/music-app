import SwiftUI

struct SongCard: View {

    let song: Song

    var body: some View {

        HStack(spacing: 12) {

            let url = song.image_url.flatMap { URL(string: $0) }

            AsyncImage(url: url) { phase in

                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                default:
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.08))

                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(width: 52, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 3) {

                Text(song.title)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(1)

                Text(song.artist?.name ?? "Unknown Artist")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "play.fill")
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 14, weight: .semibold))
                .padding(.trailing, 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
