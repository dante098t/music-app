import SwiftUI
import AVFoundation
import Supabase

// MARK: - Wheel Menu
enum WheelMenu: String, CaseIterable {
    case favorite = "Favorite"
    case shuffle = "Shuffle"
    case repeatSong = "Repeat"
    case lyrics = "Lyrics"
    
    var icon: String {
        switch self {
        case .favorite: return "heart.fill"
        case .shuffle: return "shuffle"
        case .repeatSong: return "repeat"
        case .lyrics: return "music.note"
        }
    }
}

// MARK: - PLAYER VIEW
struct PlayerView: View {
    
    let song: Song
    let songs: [Song]
    @State private var selectedArtist: Artist?
    @State private var showArtistDetail = false
    @StateObject private var player = AudioPlayerService.shared
    @StateObject private var favoriteManager = FavoriteManager.shared
    @StateObject private var recentlyPlayedManager = RecentlyPlayedManager.shared
    
    @State private var currentIndex: Int
    @State private var volume: Float = 0.5
    @State private var rotation: Double = 0
    @State private var lastAngle: Double = 0
    @State private var wheelAccumulator: Double = 0
    @State private var shuffledSongs: [Song] = []
    @State private var isFavorite = false
    @State private var previousTapCount = 0
    
    @State private var isSeeking = false
    @State private var showMenu = false
    @State private var selectedMenuIndex = 0
    @State private var showQueue = false
    
    @State private var artist: Artist?
    
    init(song: Song, songs: [Song]) {
        self.song = song
        self.songs = songs
        _currentIndex = State(initialValue: songs.firstIndex { $0.id == song.id } ?? 0)
    }
    
    var currentSong: Song {
        currentSongList[currentIndex]
    }
    
    var currentSongList: [Song] {
        shuffledSongs.isEmpty ? songs : shuffledSongs
    }
    
    var glowColor: Color {
        isFavorite ? .red : (showMenu ? .cyan : .white)
    }
    
    var centerIcon: String {
        if isSeeking { return "goforward" }
        if showMenu {
            return WheelMenu.allCases[selectedMenuIndex].icon
        }
        return player.isPlaying ? "pause.fill" : "play.fill"
    }
    
    var currentModeText: String {
        if isSeeking { return "Seek Mode" }
        if showMenu { return WheelMenu.allCases[selectedMenuIndex].rawValue }
        return "Now Playing"
    }
    
    var body: some View {
        GeometryReader { geo in
            let isSmall = geo.size.height < 750
            let albumSize = isSmall ? geo.size.width * 0.58 : geo.size.width * 0.68
            let wheelSize = isSmall ? geo.size.width * 0.58 : geo.size.width * 0.64
            let centerSize = wheelSize * 0.4
            
            ZStack {
                AnimatedBackgroundView()
                
                LinearGradient(colors: [.black.opacity(0.7), .white.opacity(0.15), .black.opacity(0.9)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isSmall ? 16 : 24) {
                        Spacer(minLength: isSmall ? 10 : 20)
                        
                        // MARK: Album Art
                        AsyncImage(url: URL(string: currentSong.image_url ?? "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: { ProgressView() }
                        .frame(width: albumSize, height: albumSize)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: glowColor.opacity(0.7), radius: 25)
                        
                        // Song Info
                        VStack(spacing: 6) {
                            Text(currentSong.title ?? "Unknown")
                                .font(.system(size: isSmall ? 24 : 30, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(currentSong.artist?.name ?? "Unknown Artist")
                                .foregroundColor(.gray)
                                .font(.system(size: isSmall ? 18 : 22))
                        }
                        // MARK: Progress Bar
                        
                        VStack(spacing: 8) {

                            Slider(

                                value: Binding(

                                    get: { player.currentTime },

                                    set: { newValue in

                                        player.seek(to: newValue)

                                    }

                                ),

                                in: 0...max(player.duration, 1)

                            )

                            .tint(.white) // bỏ màu cam

                            HStack {

                                Text(formatTime(player.currentTime))

                                    .foregroundColor(.gray)

                                    .font(.caption)

                                Spacer()

                                Text(formatTime(player.duration))

                                    .foregroundColor(.gray)

                                    .font(.caption)

                            }

                        }

                        .padding(.horizontal)
                        // MARK: ABOUT THIS ARTIST
                        if let artist = artist {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About this Artist")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ArtistBannerView(
                                    artistName: artist.name,
                                    imageURL: artist.avatar_url,
                                    bio: artist.bio
                                ) {
                                    showArtistDetail = true
                                }
                            }
                        }
                        
                        Spacer(minLength: isSmall ? 30 : 50)
                    }
                    .padding(.horizontal)
                }
            }
                        
                        // MARK: WHEEL CONTROL
                        ZStack {
                            // Volume Ring
                            Circle()
                                .trim(from: 0, to: CGFloat(volume))
                                .stroke(glowColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: wheelSize + 15, height: wheelSize + 15)
                            
                            // Main Wheel
                            Circle()
                                .fill(LinearGradient(colors: [Color.white.opacity(0.22), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: wheelSize, height: wheelSize)
                                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                                .rotationEffect(.degrees(rotation))
                                .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: rotation)
                                .gesture(
                                    DragGesture()
                                        .onChanged { handleWheelDrag($0, wheelSize: wheelSize) }
                                        .onEnded { _ in lastAngle = 0; wheelAccumulator = 0 }
                                )
                            
                            // Queue Button
                            VStack {
                                Button { showQueue.toggle() } label: {
                                    Text("QUEUE")
                                        .font(.system(size: isSmall ? 16 : 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding(.top, wheelSize * 0.12)
                            
                            // Previous Button
                            HStack {
                                Button { haptic(); handlePreviousTap() } label: {
                                    Image(systemName: "backward.fill")
                                        .font(.system(size: isSmall ? 24 : 28))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding(.leading, wheelSize * 0.28)
                            
                            // Next Button
                            HStack {
                                Spacer()
                                Button { haptic(); nextSong() } label: {
                                    Image(systemName: "forward.fill")
                                        .font(.system(size: isSmall ? 24 : 28))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.trailing, wheelSize * 0.28)
                            
                            // Play/Pause Button
                            VStack {
                                Spacer()
                                Button {
                                    haptic()
                                    if showMenu {
                                        selectMenu()
                                    } else {
                                        player.isPlaying ? player.pause() : player.resume()
                                    }
                                } label: {
                                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: isSmall ? 28 : 34))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, wheelSize * 0.12)
                            
                            // Center Button
                            Button {
                                haptic()
                                handleCenterTap()
                            } label: {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.14),
                                                Color.white.opacity(0.04)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: centerSize, height: centerSize)
                                    .overlay {
                                        Circle()
                                            .stroke(glowColor.opacity(0.6), lineWidth: 2)
                                    
                                    }
                            }
                        }
                        .frame(height: wheelSize + 40)
                        
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQueue) {
            QueueView(currentSongList: currentSongList, currentIndex: $currentIndex, onPlay: playCurrentSong)
        }
        .onAppear {
            RecentlyPlayedManager.shared.add(song)
            player.setVolume(volume)
            isFavorite = favoriteManager.isFavorite(currentSong)
            
            Task { await fetchArtist() }
            playCurrentSong()
            
            player.onSongFinished = { nextSong() }
        }
    }
    
    // MARK: - WHEEL GESTURE
    private func handleWheelDrag(_ value: DragGesture.Value, wheelSize: CGFloat) {
        let center = CGPoint(x: wheelSize/2, y: wheelSize/2)
        let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
        let angle = atan2(vector.dy, vector.dx) * 180 / .pi
        
        if lastAngle == 0 {
            lastAngle = angle
            return
        }
        
        var delta = angle - lastAngle
        if delta > 180 { delta -= 360 }
        if delta < -180 { delta += 360 }
        
        lastAngle = angle
        if abs(delta) < 1.5 { return }
        
        rotation += delta * 0.25
        wheelAccumulator += delta
        
        if isSeeking {
            if wheelAccumulator > 12 {
                player.seek(to: min(player.currentTime + 5, player.duration))
                wheelAccumulator = 0
                haptic()
            } else if wheelAccumulator < -12 {
                player.seek(to: max(player.currentTime - 5, 0))
                wheelAccumulator = 0
                haptic()
            }
            return
        }
        
        if showMenu {
            if wheelAccumulator > 18 {
                selectedMenuIndex = min(selectedMenuIndex + 1, WheelMenu.allCases.count - 1)
                wheelAccumulator = 0
                haptic()
            } else if wheelAccumulator < -18 {
                selectedMenuIndex = max(selectedMenuIndex - 1, 0)
                wheelAccumulator = 0
                haptic()
            }
            return
        }
        
        volume = max(0, min(1, volume + (delta > 0 ? 0.01 : -0.01)))
        player.setVolume(volume)
    }
    
    private func handleCenterTap() {
        if !isSeeking && !showMenu {
            isSeeking = true
        } else if isSeeking {
            isSeeking = false
            showMenu = true
            selectedMenuIndex = 0
        } else if showMenu {
            showMenu = false
        }
    }
    
    private func selectMenu() {
        let selected = WheelMenu.allCases[selectedMenuIndex]
        switch selected {
        case .favorite: toggleFavorite()
        case .shuffle: shuffleSongs()
        case .repeatSong:
            player.seek(to: 0)
            player.resume()
        case .lyrics:
            print("Lyrics Open") // TODO: Show Lyrics View
        }
        showMenu = false
    }
    
    // MARK: - OTHER FUNCTIONS
    func toggleFavorite() {
        favoriteManager.toggle(currentSong)
        isFavorite = favoriteManager.isFavorite(currentSong)
    }
    
    func shuffleSongs() {
        shuffledSongs = songs.shuffled()
        currentIndex = 0
        playCurrentSong()
    }
    
    func haptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func playCurrentSong() {
        player.play(url: currentSong.audio_url ?? "")
    }
    
    func nextSong() {
        currentIndex = (currentIndex + 1) % currentSongList.count
        playCurrentSong()
    }
    
    func previousSong() {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : currentSongList.count - 1
        playCurrentSong()
    }
    
    func handlePreviousTap() {
        previousTapCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.previousTapCount == 1 {
                player.seek(to: 0)
            } else {
                self.previousSong()
            }
            self.previousTapCount = 0
        }
    }
    
    func fetchArtist() async {
        do {
            let response: [Artist] = try await SupabaseService.shared.client
                .from("artists")
                .select("*")
                 .eq("id", value: "\(currentSong.artist_id)")
                .execute()
                .value
            self.artist = response.first
            print(" Artist loaded: \(self.artist?.name ?? "nil")")
        } catch {
            print(" Artist fetch error:", error)
        }
    }
    
    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

// MARK: - QUEUE VIEW
struct QueueView: View {
    let currentSongList: [Song]
    @Binding var currentIndex: Int
    let onPlay: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(currentSongList.enumerated()), id: \.element.id) { index, song in
                    Button {
                        currentIndex = index
                        onPlay()
                    } label: {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                                image.resizable().scaledToFill()
                            } placeholder: { Color.gray.opacity(0.3) }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading) {
                                Text(song.title ?? "Unknown")
                                    .foregroundColor(currentIndex == index ? .purple : .white)
                                Text(song.artist?.name ?? "Unknown Artist")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if currentIndex == index {
                                Image(systemName: "speaker.wave.3.fill").foregroundColor(.purple)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Queue")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - ARTIST BANNER VIEW
struct ArtistBannerView: View {

    let artistName: String

    let imageURL: String?

    let bio: String?

    var onTap: () -> Void

    var body: some View {

        Button(action: {

            onTap()

        }) {

            HStack(spacing: 16) {

                // MARK: ARTIST IMAGE (4:3 RATIO)

                AsyncImage(url: URL(string: imageURL ?? "")) { phase in

                    switch phase {

                    case .empty:

                        RoundedRectangle(cornerRadius: 14)

                            .fill(Color.gray.opacity(0.2))

                    case .success(let image):

                        image

                            .resizable()

                            .scaledToFill()

                    case .failure:

                        RoundedRectangle(cornerRadius: 14)

                            .fill(Color.gray.opacity(0.3))

                            .overlay(

                                Image(systemName: "person.fill")

                                    .foregroundColor(.white.opacity(0.5))

                            )

                    @unknown default:

                        EmptyView()

                    }

                }

                .frame(width: 92, height: 69) // 👈 4:3 ratio

                .clipShape(RoundedRectangle(cornerRadius: 14))

                .overlay(

                    RoundedRectangle(cornerRadius: 14)

                        .stroke(Color.white.opacity(0.15), lineWidth: 1)

                )

                // MARK: INFO

                VStack(alignment: .leading, spacing: 6) {

                    Text(artistName)

                        .font(.headline.bold())

                        .foregroundColor(.white)

                    Text(bio ?? "Artist • Tap to view profile")

                        .font(.caption)

                        .foregroundColor(.gray)

                        .lineLimit(2)

                    // mini badge

                    HStack(spacing: 6) {

                        Image(systemName: "music.microphone")

                            .font(.caption2)

                        Text("Artist")

                            .font(.caption2.bold())

                    }

                    .foregroundColor(.white.opacity(0.7))

                    .padding(.horizontal, 8)

                    .padding(.vertical, 4)

                    .background(Color.white.opacity(0.08))

                    .clipShape(Capsule())

                }

                Spacer()

                Image(systemName: "chevron.right")

                    .foregroundColor(.white.opacity(0.5))

            }

            .padding(14)

            .background(

                ZStack {

                    RoundedRectangle(cornerRadius: 20)

                        .fill(.ultraThinMaterial)

                    LinearGradient(

                        colors: [

                            Color.white.opacity(0.06),

                            Color.clear

                        ],

                        startPoint: .topLeading,

                        endPoint: .bottomTrailing

                    )

                }

            )

            .overlay(

                RoundedRectangle(cornerRadius: 20)

                    .stroke(Color.white.opacity(0.08), lineWidth: 1)

            )

        }

        .buttonStyle(.plain)

        .padding(.horizontal)

    }

}
