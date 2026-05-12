import Foundation
import SwiftUI
import AVFoundation
import Combine

@MainActor
final class AudioPlayerService: ObservableObject {

    static let shared =
    AudioPlayerService()

    // MARK: Player

    private var player:
    AVPlayer?

    // MARK: States

    @Published var isPlaying =
    false

    @Published var currentTime:
    Double = 0

    @Published var duration:
    Double = 1

    // MARK: Repeat

    @Published var isRepeatEnabled =
    false

    // MARK: Callback

    var onSongFinished:
    (() -> Void)?

    // MARK: Timer

    private var timer:
    Timer?

    // MARK: Playback Mode

    enum PlaybackOption:
    String,
    CaseIterable {

        case album = "Album"

        case shuffle = "Shuffle"
    }

    // MARK: Init

    private init() {}

    // MARK: Play

    func play(
        url: String
    ) {

        guard let audioURL =
        URL(string: url)
        else {
            return
        }

        // MARK: Remove old observers

        NotificationCenter.default.removeObserver(
            self
        )

        // MARK: Player Item

        let playerItem =
        AVPlayerItem(
            url: audioURL
        )

        // MARK: Create Player

        player = AVPlayer(
            playerItem: playerItem
        )

        // MARK: Play

        player?.play()

        isPlaying = true

        setupDuration()

        startTimer()

        // MARK: Song Finished

        NotificationCenter.default.addObserver(
            forName:
                .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in

            guard let self else {
                return
            }

            // MARK: Repeat Current Song

            if self.isRepeatEnabled {

                self.seek(to: 0)

                self.resume()

            } else {

                self.isPlaying = false

                self.onSongFinished?()
            }
        }
    }

    // MARK: Pause

    func pause() {

        player?.pause()

        isPlaying = false
    }

    // MARK: Resume

    func resume() {

        player?.play()

        isPlaying = true
    }

    // MARK: Stop

    func stop() {

        player?.pause()

        player = nil

        isPlaying = false

        currentTime = 0

        duration = 1

        timer?.invalidate()
    }

    // MARK: Seek

    func seek(
        to seconds: Double
    ) {

        let time =
        CMTime(
            seconds: seconds,
            preferredTimescale: 600
        )

        player?.seek(
            to: time
        )
    }

    // MARK: Volume

    func setVolume(
        _ value: Float
    ) {

        player?.volume = value
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
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(song.title)
                                        .foregroundColor(currentIndex == index ? .purple : .white)
                                        .fontWeight(currentIndex == index ? .semibold : .regular)
                                    
                                    Text(song.artist?.name ?? "Unknown Artist")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if currentIndex == index {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .foregroundColor(.purple)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Queue")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                        }
                    }
                }
            }
        }
    }

    // MARK: Duration

    private func setupDuration() {

        guard let item =
        player?.currentItem
        else {
            return
        }

        let seconds =
        item.asset.duration.seconds

        if seconds.isFinite {

            duration = seconds

        } else {

            duration = 1
        }
    }

    // MARK: Timer

    private func startTimer() {

            timer?.invalidate()

            timer =
            Timer.scheduledTimer(
                withTimeInterval: 0.5,
                repeats: true
            ) { [weak self] _ in

                guard let self,
                      let player =
                        self.player
                else {
                    return
                }

                let seconds =
                player.currentTime()
                    .seconds

                if seconds.isFinite {

                    self.currentTime =
                    seconds
                }
        }
    }

    // MARK: Deinit

    deinit {

        NotificationCenter.default
            .removeObserver(self)

        timer?.invalidate()
    }
}
