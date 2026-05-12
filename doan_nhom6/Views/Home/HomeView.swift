import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()

    @StateObject private var recentManager =
    RecentlyPlayedManager.shared

    @State private var searchText = ""
    @State private var showMenu = false

    var body: some View {

        ZStack(alignment: .leading) {

            // MARK: MAIN

            ZStack {

                AnimatedBackgroundView()

                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 28) {

                        headerSection

                        searchSection

                        PremiumBanner()

                        trendingSection

                        recentlyPlayedSection
                    }
                    .padding()
                }

                if showMenu {

                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {

                            withAnimation {

                                showMenu = false
                            }
                        }
                }
            }

            // MARK: SIDE MENU

            SideMenuView(
                recentSongs: recentManager.songs,
                favoriteSongs: viewModel.favoriteSongs,
                savedAlbums: viewModel.savedAlbums,
                isPresented: $showMenu
            )
            .frame(width: 300)
            .offset(x: showMenu ? 0 : -320)
            .animation(.spring(response: 0.35), value: showMenu)
        }
        .preferredColorScheme(.dark)
        .task {

            await viewModel.fetchSongs()
            await viewModel.fetchAlbums()
        }
    }
}
extension HomeView {

    var headerSection: some View {

        HStack {

            Button {

                withAnimation {
                    showMenu.toggle()
                }

            } label: {

                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {

                Text("Welcome Back")
                    .foregroundColor(.gray)

                Text("Discover Music")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            Spacer()

            Image(systemName: "bell.fill")
                .foregroundColor(.white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    var searchSection: some View {

        HStack {

            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search songs, artists...", text: $searchText)
                .foregroundColor(.white)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var trendingSection: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("Trending Albums")
                .font(.title2.bold())
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 20) {

                    ForEach(viewModel.albums) { album in

                        NavigationLink {

                            AlbumDetailView(
                                album: album,
                                songs: viewModel.songs.filter { $0.album_id == album.id }
                            )

                        } label: {

                            AlbumCard(album: album)
                        }
                    }
                }
            }
        }
    }

    var recentlyPlayedSection: some View {

        VStack(alignment: .leading, spacing: 18) {

            HStack {

                Text("Recently Played")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Spacer()

                NavigationLink {

                    RecentlyPlayedView(songs: recentManager.songs)

                } label: {

                    Text("See All")
                        .foregroundColor(.pink)
                }
            }

            VStack(spacing: 16) {

                ForEach(Array(viewModel.songs.prefix(5))) { song in

                    NavigationLink {

                        PlayerView(song: song, songs: viewModel.songs)

                    } label: {

                        SongCard(song: song)
                    }
                }
            }
        }
    }
}
