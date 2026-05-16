import SwiftUI
import AVFoundation
import Supabase

// MARK: - PLAYER MODE

enum PlayerMode {

    case normal
    case seek
    case favorite
    case options
}

// MARK: - WHEEL MENU

enum WheelMenu: String, CaseIterable {

    case off = "Off"
    case shuffle = "Shuffle"
    case repeatSong = "Repeat"

    var icon: String {

        switch self {

        case .off:
            return "power"

        case .shuffle:
            return "shuffle"

        case .repeatSong:
            return "repeat"
        }
    }
}

// MARK: - PLAYER VIEW

struct PlayerView: View {
    
    // MARK: DATA
    
    let song: Song
    let songs: [Song]
    
    // MARK: PLAYER
    
    @StateObject private var player =
    AudioPlayerService.shared
    
    @StateObject private var favoriteManager =
    FavoriteManager.shared
    
    // MARK: STATES
    
    @State private var currentIndex: Int
    
    @State private var volume: Float = 0.5
    @State private var artist: Artist?
    @State private var rotation: Double = 0
    @State private var lastAngle: Double = 0
    @State private var wheelAccumulator: Double = 0
    
    @State private var previousTapCount = 0
    
    @State private var playerMode: PlayerMode = .normal
    
    @State private var selectedMenuIndex = 0
    
    @State private var isShuffle = false
    @State private var isRepeat = false
    
    @State private var shuffledSongs: [Song] = []
    
    // MARK: INIT
    
    init(song: Song, songs: [Song]) {
        
        self.song = song
        self.songs = songs
        
        _currentIndex = State(
            initialValue:
                songs.firstIndex {
                    $0.id == song.id
                } ?? 0
        )
    }
    
    var isFavorite: Bool {

        favoriteManager.isFavorite(currentSong)

    }
    // MARK: CURRENT SONG
    
    var currentSong: Song {
        
        currentSongList[currentIndex]
    }
    
    var currentSongList: [Song] {
        
        shuffledSongs.isEmpty
        ? songs
        : shuffledSongs
    }
    
    // MARK: GLOW
    // MARK: GLOW
    // MARK: GLOW

    var glowColor: Color {

        // ĐÃ FAVORITE -> luôn đỏ ưu tiên cao nhất

        if isFavorite {

            return .red
        }

        // OPTIONS MODE

        if playerMode == .options {

            return .white
        }

        // ĐANG CHỌN FAVORITE MODE NHƯNG CHƯA FAVORITE

        if playerMode == .favorite {

            return .white
        }

        return .white
    }
    
    // MARK: BODY
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            GeometryReader { geo in
                
                let wheelSize =
                geo.size.width * 0.64
                
                let albumSize =
                geo.size.width * 0.68
                
                let centerSize =
                wheelSize * 0.38
                
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    // MARK: ALBUM
                    
                    AsyncImage(
                        url: URL(
                            string:
                                currentSong.image_url ?? ""
                        )
                    ) { image in
                        
                        image
                            .resizable()
                            .scaledToFill()
                        
                    } placeholder: {
                        
                        ProgressView()
                    }
                    .frame(
                        width: albumSize,
                        height: albumSize
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 28
                        )
                    )
                    .shadow(
                        color: glowColor.opacity(0.6),
                        radius: 25
                    )
                    
                    // MARK: SONG INFO
                    
                    VStack(spacing: 6) {
                        
                        Text(
                            currentSong.title
                            ?? "Unknown"
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)
                        
                        Text(
                            currentSong.artist?.name
                            ?? "Unknown Artist"
                        )
                        .foregroundColor(.gray)
                        .font(.title3)
                    }
                    
                    // MARK: PROGRESS
                    
                    if playerMode != .options {
                        
                        VStack(spacing: 8) {
                            
                            Slider(
                                
                                value: Binding(
                                    
                                    get: {
                                        
                                        player.currentTime
                                    },
                                    
                                    set: { newValue in
                                        
                                        player.seek(
                                            to: newValue
                                        )
                                    }
                                    
                                ),
                                
                                in: 0...max(
                                    player.duration,
                                    1
                                )
                            )
                            .tint(.white)
                            
                            HStack {
                                
                                Text(
                                    formatTime(
                                        player.currentTime
                                    )
                                )
                                
                                Spacer()
                                
                                Text(
                                    formatTime(
                                        player.duration
                                    )
                                )
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    
                    // MARK: OPTIONS MODE
                    
                    if playerMode == .options {
                        
                        HStack(spacing: 42) {
                            
                            ForEach(
                                Array(
                                    WheelMenu
                                        .allCases
                                        .enumerated()
                                ),
                                id: \.offset
                            ) { index, option in
                                
                                Image(
                                    systemName:
                                        option.icon
                                )
                                
                                .font(
                                    .system(
                                        size: 30,
                                        weight: .bold
                                    )
                                )
                                
                                .foregroundColor(
                                    
                                    selectedMenuIndex == index
                                    ? .white
                                    : .gray.opacity(0.45)
                                )
                                
                                .scaleEffect(
                                    selectedMenuIndex == index
                                    ? 1.25
                                    : 1
                                )
                                
                                .shadow(
                                    
                                    color:
                                        
                                        selectedMenuIndex == index
                                    ? .white.opacity(0.8)
                                    : .clear,
                                    
                                    radius: 12
                                )
                                
                                .animation(
                                    .easeInOut(duration: 0.15),
                                    value: selectedMenuIndex
                                )
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    // MARK: WHEEL
                    
                    ZStack {
                        
                        // OUTER RING
                        
                        Circle()
                        
                            .stroke(
                                Color.white.opacity(0.08),
                                lineWidth: 10
                            )
                        
                        // ACTIVE RING
                        
                        Circle()
                        
                            .trim(
                                from: 0,
                                to: CGFloat(volume)
                            )
                        
                            .stroke(
                                
                                glowColor,
                                
                                style: StrokeStyle(
                                    
                                    lineWidth: 8,
                                    
                                    lineCap: .round
                                )
                            )
                        
                            .rotationEffect(
                                .degrees(-90)
                            )
                        
                        // MAIN WHEEL
                        
                        Circle()
                        
                            .fill(
                                
                                LinearGradient(
                                    
                                    colors: [
                                        
                                        Color.white.opacity(0.18),
                                        
                                        Color.white.opacity(0.05)
                                        
                                    ],
                                    
                                    startPoint: .topLeading,
                                    
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                            .overlay(
                                
                                Circle()
                                
                                    .stroke(
                                        Color.white.opacity(0.08),
                                        lineWidth: 1
                                    )
                            )
                        
                            .rotationEffect(
                                .degrees(rotation)
                            )
                        
                            .gesture(
                                
                                DragGesture(
                                    minimumDistance: 0
                                )
                                
                                .onChanged {
                                    
                                    handleWheelDrag(
                                        $0,
                                        wheelSize: wheelSize
                                    )
                                }
                                
                                    .onEnded { _ in
                                        
                                        lastAngle = 0
                                        wheelAccumulator = 0
                                    }
                            )
                        
                        // TOP
                        
                        VStack {
                            
                            Text("MENU")
                            
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .bold
                                    )
                                )
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.top, wheelSize * 0.14)
                        
                        // LEFT
                        
                        HStack {
                            
                            Button {
                                
                                handlePreviousTap()
                                
                            } label: {
                                
                                Image(
                                    systemName:
                                        "backward.fill"
                                )
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(
                            .leading,
                            wheelSize * 0.16
                        )
                        
                        // RIGHT
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                
                                nextSong()
                                
                            } label: {
                                
                                Image(
                                    systemName:
                                        "forward.fill"
                                )
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            }
                        }
                        .padding(
                            .trailing,
                            wheelSize * 0.16
                        )
                        
                        // PLAY
                        
                        VStack {
                            
                            Spacer()
                            
                            Button {

                                // FAVORITE CONFIRM
                                if playerMode == .favorite {

                                    toggleFavorite()


                                    return
                                }
                                // OPTIONS CONFIRM

                                if playerMode == .options {

                                    applyCurrentOption()

                                    playerMode = .normal

                                    return

                                }

                                // NORMAL PLAY / PAUSE

                                if player.isPlaying {

                                    player.pause()

                                } else {

                                    player.resume()

                                }

                            } label: {
                                
                                Image(
                                    systemName:
                                        player.isPlaying
                                    ? "pause.fill"
                                    : "play.fill"
                                )
                                .font(.system(size: 34))
                                .foregroundColor(.white)
                            }
                        }
                        .padding(
                            .bottom,
                            wheelSize * 0.14
                        )
                        
                        // CENTER BUTTON
                        
                        Button {
                            
                            handleCenterTap()
                            
                        } label: {
                            
                            Circle()
                            
                                .fill(
                                    Color.white.opacity(0.08)
                                )
                            
                                .overlay {
                                    
                                    switch playerMode {
                                        
                                    case .seek:
                                        
                                        Image(
                                            systemName:
                                                "goforward"
                                        )
                                        
                                    case .favorite:
                                        
                                        Image(
                                            systemName:
                                                "heart.fill"
                                        )
                                        
                                    case .options:
                                        
                                        Image(
                                            systemName:
                                                WheelMenu
                                                .allCases[
                                                    selectedMenuIndex
                                                ]
                                                .icon
                                        )
                                        
                                    case .normal:
                                        
                                        EmptyView()
                                    }
                                }
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        .frame(
                            width: centerSize,
                            height: centerSize
                        )
                    }
                    .frame(
                        width: wheelSize,
                        height: wheelSize
                    )
                    
                    Spacer()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .onReceive(
                    
                    NotificationCenter.default.publisher(
                        
                        for: .AVPlayerItemDidPlayToEndTime
                        
                    )
                    
                ) { _ in
                    
                    nextSong()
                    
                }
                
                .onAppear {
                    
                    RecentlyPlayedManager.shared.add(currentSong)
                    
                    player.setVolume(volume)
                    DispatchQueue.main.async {
                        
                       

                    }
                    
                    Task { await fetchArtist() }
                    
                    playCurrentSong()
                    
                    player.onSongFinished = { nextSong() }
                }
                .onChange(of: currentSong.id) { _ in

                    
                }
            }
        }
        
    }
    // MARK: WHEEL DRAG
    
    private func handleWheelDrag(
        _ value: DragGesture.Value,
        wheelSize: CGFloat
    ) {
        
        let center = CGPoint(
            x: wheelSize / 2,
            y: wheelSize / 2
        )
        
        let dx =
        value.location.x - center.x
        
        let dy =
        value.location.y - center.y
        
        let angle =
        atan2(dy, dx) * 180 / .pi
        
        if lastAngle == 0 {
            
            lastAngle = angle
            return
        }
        
        var delta =
        angle - lastAngle
        
        if delta > 180 {
            
            delta -= 360
        }
        
        if delta < -180 {
            
            delta += 360
        }
        
        lastAngle = angle
        
        if abs(delta) < 0.3 {
            
            return
        }
        
        rotation += delta * 0.8
        wheelAccumulator += delta
        
        // SEEK MODE
        
        if playerMode == .seek {
            
            if wheelAccumulator > 15 {
                
                player.seek(
                    to: min(
                        player.currentTime + 5,
                        player.duration
                    )
                )
                
                wheelAccumulator = 0
                
            } else if wheelAccumulator < -15 {
                
                player.seek(
                    to: max(
                        player.currentTime - 5,
                        0
                    )
                )
                
                wheelAccumulator = 0
            }
            
            return
        }
        
        // OPTIONS MODE
        
        if playerMode == .options {
            
            if wheelAccumulator > 30 {
                
                selectedMenuIndex =
                (selectedMenuIndex + 1)
                % WheelMenu.allCases.count
                
                applyCurrentOption()
                
                wheelAccumulator = 0
                
            } else if wheelAccumulator < -30 {
                
                selectedMenuIndex =
                (selectedMenuIndex - 1
                 + WheelMenu.allCases.count)
                % WheelMenu.allCases.count
                
                applyCurrentOption()
                
                wheelAccumulator = 0
            }
            
            return
        }
        
        // VOLUME
        
        volume += delta > 0
        ? 0.01
        : -0.01
        
        volume = min(
            max(volume, 0),
            1
        )
        
        player.setVolume(volume)
    }
    
    // MARK: CENTER TAP
    
    private func handleCenterTap() {
        
        switch playerMode {
            
        case .normal:
            
            playerMode = .seek
            
        case .seek:
            
            playerMode = .favorite
            
            
            
        case .favorite:
            
            playerMode = .options
            
        case .options:
            
            playerMode = .normal
        }
    }
    
    // MARK: APPLY OPTION
    
    func applyCurrentOption() {
        
        let selected =
        WheelMenu.allCases[selectedMenuIndex]
        
        switch selected {
            
        case .off:
            
            isShuffle = false
            isRepeat = false
            
        case .shuffle:
            
            isShuffle = true
            isRepeat = false
            
        case .repeatSong:
            
            isRepeat = true
            isShuffle = false
        }
    }
    // MARK: FAVORITE
    func toggleFavorite() {

        withAnimation(.easeInOut(duration: 0.25)) {

            favoriteManager.toggle(currentSong)

        }

    }
    // MARK: PLAY
    
    func playCurrentSong() {

        player.play(

            url: currentSong.audio_url ?? ""

        )


    }
    // MARK: NEXT
    
    func nextSong() {
        
        // REPEAT MODE
        
        if isRepeat {
            
            player.seek(to: 0)
            
            player.resume()
            
            return
        }
        
        // SHUFFLE MODE
        
        
        
        if isShuffle {
            
            currentIndex =
            Int.random(
                in: 0..<currentSongList.count
                
            )
            
        } else {
            
            currentIndex =
            (currentIndex + 1)
            % currentSongList.count
        }
        
        playCurrentSong()
    }
    
    // MARK: PREVIOUS
    
    func previousSong() {
        
        currentIndex =
        currentIndex > 0
        ? currentIndex - 1
        : currentSongList.count - 1
        
        playCurrentSong()
    }
    
    // MARK: PREVIOUS TAP
    
    func handlePreviousTap() {
        
        previousTapCount += 1
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            
            if self.previousTapCount == 1 {
                
                player.seek(to: 0)
                
            } else {
                
                self.previousSong()
            }
            
            self.previousTapCount = 0
        }
    }
    
    // MARK: FORMAT TIME
    
    func formatTime(
        _ seconds: Double
    ) -> String {
        
        let mins =
        Int(seconds) / 60
        
        let secs =
        Int(seconds) % 60
        
        return String(
            format: "%d:%02d",
            mins,
            secs
        )
    }
    private func fetchArtist() async {
        
        do {
            
            let response: [Artist] = try await SupabaseService.shared.client
            
                .from("artists")
            
                .select("*")
            
                .eq("id", value: "\(currentSong.artist_id)")
            
                .execute()
            
                .value
            
            
            
            self.artist = response.first
            
            
            
        } catch {
            
            print(error)
            
        }
    }
}
