import SwiftUI

struct SongCard: View {

    let song: Song

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 52, height: 52) // 👈 nhỏ lại cho mini
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 3) {

                Text(song.title)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(song.artist?.name ?? "Unknown Artist")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 👈 quan trọng

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
