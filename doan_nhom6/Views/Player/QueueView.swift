import SwiftUI

struct QueueView: View {

    let currentSongList: [Song]

    @Binding var currentIndex: Int

    let onPlay: () -> Void

    var body: some View {

        NavigationStack {

            ZStack {

                AnimatedBackgroundView()

                LinearGradient(
                    colors: [
                        .black.opacity(0.75),
                        .clear,
                        .black.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if currentSongList.isEmpty {

                    emptyState

                } else {

                    ScrollView(
                        showsIndicators: false
                    ) {

                        LazyVStack(
                            spacing: 16
                        ) {

                            ForEach(
                                Array(
                                    currentSongList.enumerated()
                                ),
                                id: \.element.id
                            ) { index, song in

                                Button {

                                    currentIndex = index

                                    onPlay()

                                } label: {

                                    queueCard(
                                        song: song,
                                        index: index
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Queue")

            .navigationBarTitleDisplayMode(.inline)

            .preferredColorScheme(.dark)
        }
    }
}

// MARK: COMPONENTS

extension QueueView {

    var emptyState: some View {

        VStack(spacing: 18) {

            Image(systemName: "music.note.list")

                .font(.system(size: 52))

                .foregroundColor(.gray)

            Text("Queue is Empty")

                .font(.title3.bold())

                .foregroundColor(.white)

            Text("Songs added to queue will appear here.")

                .foregroundColor(.gray)
        }
    }

    func queueCard(
        song: Song,
        index: Int
    ) -> some View {

        HStack(spacing: 14) {

            AsyncImage(
                url: URL(
                    string:
                        song.image_url ?? ""
                )
            ) { phase in

                switch phase {

                case .success(let image):

                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()

                default:

                    RoundedRectangle(
                        cornerRadius: 14
                    )
                    .fill(
                        Color.white.opacity(0.08)
                    )
                }
            }
            .frame(width: 58, height: 58)

            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(
                    song.title ?? "Unknown"
                )

                .foregroundColor(
                    currentIndex == index
                    ? .pink
                    : .white
                )

                .font(.headline)

                .lineLimit(1)

                Text(
                    song.artist?.name
                    ?? "Unknown Artist"
                )

                .font(.subheadline)

                .foregroundColor(.gray)

                .lineLimit(1)
            }

            Spacer()

            if currentIndex == index {

                Image(
                    systemName:
                        "speaker.wave.3.fill"
                )

                .foregroundColor(.pink)

                .font(.title3)
            }
        }
        .padding(14)

        .background(
            .ultraThinMaterial
        )

        .clipShape(
            RoundedRectangle(
                cornerRadius: 22
            )
        )
    }
}
