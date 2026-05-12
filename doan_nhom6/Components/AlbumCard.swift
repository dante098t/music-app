import SwiftUI

struct AlbumCard: View {
    
    let album: Album
    
    var body: some View {
        GeometryReader { geo in
            
            let width = geo.size.width
            
            VStack(alignment: .leading, spacing: 10) {
                
                AsyncImage(url: URL(string: album.cover_url ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                        ProgressView()
                    }
                }
                .frame(width: width, height: width) // 👈 auto square theo card width
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(album.artist?.name ?? "Unknown Artist")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 4)
            }
            .frame(width: width)
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(width: 160, height: 220) // 👈 quan trọng: giới hạn card ngoài
    }
}
