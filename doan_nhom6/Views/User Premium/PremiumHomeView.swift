import SwiftUI

struct PremiumHomeView: View {

    @StateObject private var viewModel =
    HomeViewModel()

    @StateObject private var recentManager =
    RecentlyPlayedManager.shared

    @State private var searchText = ""

    @State private var showMenu = false

    // MARK: SEARCH SONGS

    var filteredSongs: [Song] {

        let query = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !query.isEmpty else {
            return []
        }

        return viewModel.songs.filter { song in

            song.title
                .localizedCaseInsensitiveContains(query)

            ||
            song.artist?.name
                .localizedCaseInsensitiveContains(query) ?? false
        }
    }

    // MARK: SEARCH ALBUMS

    var filteredAlbums: [Album] {

        let query = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !query.isEmpty else {
            return []
        }

        return viewModel.albums.filter { album in

            album.title
                .localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {

        NavigationStack {

            ZStack(alignment: .leading) {

                // MARK: MAIN

                ZStack {

                    AnimatedBackgroundView()

                    ScrollView(
                        showsIndicators: false
                    ) {

                        VStack(
                            alignment: .leading,
                            spacing: 24
                        ) {

                            headerSection

                            searchSection

                            // SEARCH RESULT
                            if !searchText.isEmpty {

                                searchResultSection
                            }

                            // NORMAL HOME
                            else {

                                trendingSection

                                recentlyPlayedSection
                            }

                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    }

                    .safeAreaInset(edge: .bottom) {

                        Color.clear
                            .frame(height: 20)
                    }

                    // MARK: OVERLAY

                    if showMenu {

                        Color.black.opacity(0.45)
                            .ignoresSafeArea()

                            .onTapGesture {

                                withAnimation(.spring) {

                                    showMenu = false
                                }
                            }
                    }
                }

                // MARK: SIDE MENU

                SideMenuView(
                    recentSongs: recentManager.songs,
                    isPresented: $showMenu
                )
                .frame(width: 300)

                .offset(
                    x: showMenu
                    ? 0
                    : -300
                )

                .animation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.82
                    ),
                    value: showMenu
                )
                .zIndex(1)
            }
            .preferredColorScheme(.dark)

            .task {

                await viewModel.fetchSongs()

                await viewModel.fetchAlbums()
            }
        }
    }
}

// MARK: EXTENSION

extension PremiumHomeView {

    // MARK: HEADER

    var headerSection: some View {

        HStack {

            Button {

                withAnimation(.spring) {

                    showMenu.toggle()
                }

            } label: {

                Image(
                    systemName:
                        "line.3.horizontal"
                )
                .font(.system(size: 18))

                .foregroundColor(.white)

                .frame(
                    width: 44,
                    height: 44
                )

                .background(
                    .ultraThinMaterial
                )

                .clipShape(Circle())
            }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text("Welcome Back")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("Discover Music")
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )

                    .foregroundStyle(

                        LinearGradient(

                            colors: [
                                .white,
                                .pink
                            ],

                            startPoint: .leading,

                            endPoint: .trailing
                        )
                    )
            }

            Spacer()

            Button {

            } label: {

                Image(systemName: "bell.fill")

                    .font(.system(size: 17))

                    .foregroundColor(.white)

                    .frame(
                        width: 44,
                        height: 44
                    )

                    .background(
                        .ultraThinMaterial
                    )

                    .clipShape(Circle())
            }
        }
    }

    // MARK: SEARCH BAR

    var searchSection: some View {

        HStack(spacing: 12) {

            Image(
                systemName:
                    "magnifyingglass"
            )
            .foregroundColor(.gray)

            TextField(
                "Search songs, artists, albums...",
                text: $searchText
            )
            .foregroundColor(.white)

            if !searchText.isEmpty {

                Button {

                    searchText = ""

                } label: {

                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)

        .frame(height: 54)

        .background(
            .ultraThinMaterial
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }

    // MARK: SEARCH RESULT

    var searchResultSection: some View {

        VStack(
            alignment: .leading,
            spacing: 24
        ) {

            // SONGS

            if !filteredSongs.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Songs")
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    LazyVStack(spacing: 14) {

                        ForEach(filteredSongs) { song in

                            NavigationLink {

                                PlayerRouterView(
                                    song: song,
                                    songs: viewModel.songs
                                )

                            } label: {

                                SongCard(song: song)
                            }
                            .buttonStyle(.plain)

                            // SWIPE RIGHT
                            .swipeActions(edge: .leading) {

                                Button {

                                    QueueManager.shared
                                        .addToQueue(song)

                                } label: {

                                    Label(
                                        "Queue",
                                        systemImage:
                                            "text.badge.plus"
                                    )
                                }
                                .tint(.green)
                            }

                            // SWIPE LEFT
                            .swipeActions(edge: .trailing) {

                                Button {

                                    FavoriteManager.shared
                                        .toggle(song)

                                } label: {

                                    Label(
                                        "Favorite",
                                        systemImage:
                                            "heart.fill"
                                    )
                                }
                                .tint(.pink)
                            }
                        }
                    }
                }
            }

            // ALBUMS

            if !filteredAlbums.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    Text("Albums")
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    ScrollView(
                        .horizontal,
                        showsIndicators: false
                    ) {

                        LazyHStack(spacing: 16) {

                            ForEach(filteredAlbums) { album in

                                NavigationLink {

                                    AlbumDetailView(
                                        album: album,
                                        songs: viewModel.songs.filter {
                                            $0.album_id == album.id
                                        }
                                    )

                                } label: {

                                    AlbumCard(album: album)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }

            // EMPTY

            if filteredSongs.isEmpty &&
                filteredAlbums.isEmpty {

                VStack(spacing: 18) {

                    Image(
                        systemName:
                            "magnifyingglass"
                    )
                    .font(.system(size: 50))
                    .foregroundColor(.gray)

                    Text("No Results Found")
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    Text(
                        "Try another keyword"
                    )
                    .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 80)
            }
        }
    }

    // MARK: TRENDING

    var trendingSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Trending Albums")

                .font(.title3.bold())

                .foregroundColor(.white)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                LazyHStack(spacing: 16) {

                    ForEach(viewModel.albums) { album in

                        NavigationLink {

                            AlbumDetailView(
                                album: album,
                                songs: viewModel.songs.filter {
                                    $0.album_id == album.id
                                }
                            )

                        } label: {

                            AlbumCard(album: album)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 2)
            }
            .frame(height: 245)
        }
    }

    // MARK: RECENTLY PLAYED

    var recentlyPlayedSection: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text("Recently Played")

                    .font(.title3.bold())

                    .foregroundColor(.white)

                Spacer()

                NavigationLink {

                    RecentlyPlayedView(
                        songs: recentManager.songs
                    )

                } label: {

                    Text("See All")

                        .font(.subheadline.bold())

                        .foregroundColor(.pink)
                }
            }

            LazyVStack(spacing: 14) {

                ForEach(
                    Array(
                        viewModel.songs.prefix(5)
                    )
                ) { song in

                    NavigationLink {

                        PlayerRouterView(
                            song: song,
                            songs: viewModel.songs
                        )

                    } label: {

                        SongCard(song: song)
                    }
                    .buttonStyle(.plain)

                    // SWIPE RIGHT
                    .swipeActions(edge: .leading) {

                        Button {

                            QueueManager.shared
                                .addToQueue(song)

                        } label: {

                            Label(
                                "Queue",
                                systemImage:
                                    "text.badge.plus"
                            )
                        }
                        .tint(.green)
                    }

                    // SWIPE LEFT
                    .swipeActions(edge: .trailing) {

                        Button {

                            FavoriteManager.shared
                                .toggle(song)

                        } label: {

                            Label(
                                "Favorite",
                                systemImage:
                                    "heart.fill"
                            )
                        }
                        .tint(.pink)
                    }
                }
            }
        }
    }
}
