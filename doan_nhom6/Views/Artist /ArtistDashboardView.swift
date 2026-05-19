import SwiftUI
import Supabase
import Combine
struct ArtistDashboardView: View {

    @State private var pendingSongs: [Song] = []

    @State private var approvedSongs: [Song] = []

    @State private var rejectedSongs: [Song] = []

    @State private var totalStreams = 0

    @State private var totalRevenue: Double = 0

    @State private var isLoading = false

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [
                        .black,
                        Color.cyan.opacity(0.2),
                        .black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 24) {

                        // HEADER

                        VStack(spacing: 12) {

                            Image(systemName: "music.mic.circle.fill")
                                .font(.system(size: 72))
                                .foregroundColor(.cyan)

                            Text("Artist Dashboard")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)

                            Text("Manage your music")
                                .foregroundColor(.gray)
                        }
                        .padding(.top)

                        // ANALYTICS

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {

                            ArtistAnalyticsCard(
                                title: "Published",
                                value: "\(approvedSongs.count)",
                                icon: "music.note",
                                color: .green
                            )

                            ArtistAnalyticsCard(
                                title: "Pending",
                                value: "\(pendingSongs.count)",
                                icon: "clock.fill",
                                color: .yellow
                            )

                            ArtistAnalyticsCard(
                                title: "Streams",
                                value: "\(totalStreams)",
                                icon: "waveform",
                                color: .cyan
                            )

                            ArtistAnalyticsCard(
                                title: "Revenue",
                                value: "$\(Int(totalRevenue))",
                                icon: "dollarsign.circle.fill",
                                color: .green
                            )
                        }
                        .padding(.horizontal)

                        // QUICK ACTIONS

                        VStack(alignment: .leading, spacing: 16) {

                            Text("Quick Actions")
                                .font(.title2.bold())
                                .foregroundColor(.white)

                            NavigationLink {

                                UploadSongView()

                            } label: {

                                HStack {

                                    Image(systemName: "square.and.arrow.up.fill")

                                    Text("Upload New Song")
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        .padding(.horizontal)

                        // PENDING SONGS

                        ArtistSongSection(
                            title: "Pending Approval",
                            songs: pendingSongs,
                            color: .yellow
                        )

                        // APPROVED SONGS

                        ArtistSongSection(
                            title: "Published Songs",
                            songs: approvedSongs,
                            color: .green
                        )

                        // REJECTED SONGS

                        ArtistSongSection(
                            title: "Rejected Songs",
                            songs: rejectedSongs,
                            color: .red
                        )
                    }
                    .padding(.bottom, 40)
                }
            }
            .task {
                await fetchArtistSongs()
            }
        }
    }

    func fetchArtistSongs() async {

        guard let userId = SupabaseService.shared.client.auth.currentUser?.id else {
            return
        }

        isLoading = true

        do {

            let response: [Song] = try await SupabaseService.shared.client

                .from("songs")

                .select("*")

                .eq("artist_id", value: userId.uuidString)

                .order("created_at", ascending: false)

                .execute()

                .value

            await MainActor.run {

                self.pendingSongs = response.filter {
                    $0.status == "pending"
                }

                self.approvedSongs = response.filter {
                    $0.status == "approved"
                }

                self.rejectedSongs = response.filter {
                    $0.status == "rejected"
                }

                self.totalStreams = response.reduce(0) {
                    $0 + ($1.play_count ?? 0)
                }

                self.totalRevenue = Double(totalStreams) * 0.004

                isLoading = false
            }

        } catch {

            print(error)

            isLoading = false
        }
    }
}
struct ArtistAnalyticsCard: View {

    let title: String

    let value: String

    let icon: String

    let color: Color

    var body: some View {

        VStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)

            Text(value)
                .font(.title.bold())
                .foregroundColor(.white)

            Text(title)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.06))
        )
    }
}
struct ArtistSongSection: View {

    let title: String

    let songs: [Song]

    let color: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text(title)
                .font(.title2.bold())
                .foregroundColor(color)
                .padding(.horizontal)

            ForEach(songs) { song in

                ArtistSongRow(song: song)
                    .padding(.horizontal)
            }
        }
    }
}
struct ArtistSongRow: View {

    let song: Song

    var statusColor: Color {

        switch song.status {

        case "approved":
            return .green

        case "pending":
            return .yellow

        case "rejected":
            return .red

        default:
            return .gray
        }
    }

    var body: some View {

        HStack(spacing: 14) {

            AsyncImage(url: URL(string: song.image_url ?? "")) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                Color.gray
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 6) {

                Text(song.title ?? "Unknown")
                    .foregroundColor(.white)
                    .fontWeight(.bold)

                Text(song.genre ?? "")
                    .foregroundColor(.gray)

                Text("\(song.play_count ?? 0) streams")
                    .foregroundColor(.gray)
                    .font(.caption)
            }

            Spacer()

            VStack(spacing: 10) {

                Text(song.status ?? "pending")
                    .foregroundColor(statusColor)
                    .fontWeight(.bold)

                Menu {

                    Button("Edit") {

                    }

                    Button("Delete", role: .destructive) {

                    }

                } label: {

                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.06))
        )
    }
}
struct UploadSongView: View {

    @Environment(\.dismiss) var dismiss

    @State private var title = ""

    @State private var genre = "Pop"

    @State private var lyrics = ""

    @State private var imageURL = ""

    @State private var audioURL = ""

    @State private var isPremium = false

    @State private var isExplicit = false

    @State private var isUploading = false

    let genres = [
        "Pop",
        "Rock",
        "Hip Hop",
        "EDM",
        "Jazz",
        "Lo-fi"
    ]

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 20) {

                    Text("Upload Song")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    TextField("Song Title", text: $title)
                        .artistField()

                    TextField("Cover URL", text: $imageURL)
                        .artistField()

                    TextField("Audio URL", text: $audioURL)
                        .artistField()

                    Picker("Genre", selection: $genre) {

                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)

                    Toggle("Premium", isOn: $isPremium)
                        .foregroundColor(.white)

                    Toggle("Explicit", isOn: $isExplicit)
                        .foregroundColor(.white)

                    TextEditor(text: $lyrics)
                        .frame(height: 160)
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.white)

                    Button {
                        uploadSong()
                    } label: {

                        if isUploading {

                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()

                        } else {

                            Text("Submit For Approval")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
            }
        }
    }

    func uploadSong() {

        guard let userId = SupabaseService.shared.client.auth.currentUser?.id else {
            return
        }

        isUploading = true

        Task {

            do {

                let song = SongInsert(

                    title: title,

                    image_url: imageURL,

                    audio_url: audioURL,

                    genre: genre,

                    lyrics: lyrics,

                    artist_id: userId.uuidString,

                    is_premium: isPremium,

                    is_explicit: isExplicit,

                    status: "pending"
                )

                try await SupabaseService.shared.client

                    .from("songs")

                    .insert(song)

                    .execute()

                await MainActor.run {

                    isUploading = false

                    dismiss()
                }

            } catch {

                print(error)

                await MainActor.run {
                    isUploading = false
                }
            }
        }
    }
}
extension View {

    func artistField() -> some View {

        self
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .foregroundColor(.white)
    }
}
