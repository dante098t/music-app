import SwiftUI

struct SideMenuView: View {
    
    let recentSongs: [Song]
    let favoriteSongs: [Song]
    let savedAlbums: [Album]
    
    @Binding var isPresented: Bool   // ← Thêm Binding này
    
    var body: some View {
        ZStack {
            // Background Overlay (để tap ngoài tắt menu)
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    }
            }
            
            // Side Menu
            HStack {
                ZStack {
                    LinearGradient(
                        colors: [Color.black.opacity(0.98), Color.white.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            
                            // Profile Header
                            VStack(alignment: .leading, spacing: 16) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.pink)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Music Lover")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    Text("Free Plan")
                                        .font(.subheadline)
                                        .foregroundColor(.pink)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 60)
                            
                            // Favorite Songs
                            menuSection(title: "Favorite Songs", icon: "heart.fill")
                            if favoriteSongs.isEmpty {
                                Text("you suck")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(favoriteSongs.prefix(5)) { song in
                                    SongRow(song: song)
                                }
                            }
                            
                            // Recently Played
                            menuSection(title: "Recently Played", icon: "clock.fill")
                            if recentSongs.isEmpty {
                                Text("you suck")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(recentSongs.prefix(5)) { song in
                                    SongRow(song: song)
                                }
                            }
                            
                            // Saved Albums
                            menuSection(title: "Saved Albums", icon: "square.stack.fill")
                            if savedAlbums.isEmpty {
                                Text("album???")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(savedAlbums.prefix(4)) { album in
                                            AlbumCardMini(album: album)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            Divider().overlay(Color.white.opacity(0.15))
                            
                            // Settings & Logout
                            VStack(spacing: 20) {
                                NavigationLink {
                                    SettingsView()
                                } label: {
                                    menuItem(title: "Settings", icon: "gearshape.fill")
                                }
                                
                                Button {
                                    AuthManager.shared.signOut()
                                    isPresented = false
                                } label: {
                                    menuItem(title: "Logout", icon: "rectangle.portrait.and.arrow.right", color: .red)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(width: 300)
                .offset(x: isPresented ? 0 : -320)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Helper Views
    private func menuSection(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 28)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
    
    private func menuItem(title: String, icon: String, color: Color = .white) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 28)
            Text(title)
                .foregroundColor(color)
            Spacer()
        }
        .font(.body)
        .padding(.vertical, 4)
    }
}// MARK: - Song Row (dùng cho SideMenu)
struct SongRow: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(1)
                
                Text(song.artist?.name ?? "Unknown Artist")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - Mini Album Card
struct AlbumCardMini: View {
    let album: Album
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: album.cover_url ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.white.opacity(0.1)
            }
            .frame(width: 130, height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(album.title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(album.artist?.name ?? "Unknown")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 130)
    }
}
