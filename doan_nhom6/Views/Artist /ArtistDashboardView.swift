import SwiftUI
import Supabase

// MARK: - Models
struct SongUploadItem: Identifiable {
    let id = UUID()
    var title: String = ""
    var imageURL: String = ""
    var audioURL: String = ""
    var genre: String = "Pop"
    var lyrics: String = ""
    var isPremium: Bool = false
    var isExplicit: Bool = false
}



struct SongInsert: Encodable {
    let title: String
    let image_url: String
    let audio_url: String
    let genre: String
    let lyrics: String
    let artist_id: Int64
    let is_premium: Bool
    let is_explicit: Bool
    let status: String
}

// MARK: - Main Dashboard
struct ArtistDashboardView: View {
    @State private var songs: [Song] = []
    @State private var uploadProgress: Double = 0
    @State private var isUploading = false
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
                    colors: [.black, Color.cyan.opacity(0.2), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
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
                        
                        // Analytics
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ArtistAnalyticsCard(title: "Published", value: "\(approvedSongs.count)", icon: "music.note", color: .green)
                            ArtistAnalyticsCard(title: "Pending", value: "\(pendingSongs.count)", icon: "clock.fill", color: .yellow)
                            ArtistAnalyticsCard(title: "Streams", value: "\(totalStreams)", icon: "waveform", color: .cyan)
                            ArtistAnalyticsCard(title: "Revenue", value: "$\(Int(totalRevenue))", icon: "dollarsign.circle.fill", color: .green)
                        }
                        .padding(.horizontal)
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            NavigationLink {
                                UploadSongView()
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up.fill")
                                    Text("Upload New Songs")
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
                        
                        ArtistSongSection(title: "Pending Approval", songs: pendingSongs, color: .yellow)
                        ArtistSongSection(title: "Published Songs", songs: approvedSongs, color: .green)
                        ArtistSongSection(title: "Rejected Songs", songs: rejectedSongs, color: .red)
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
        
        guard let user = SupabaseService.shared.client.auth.currentUser else { return }
        isUploading = true
            uploadProgress = 0.0
            let total = songs.count
            var uploadedCount = 0
        isLoading = true
        
        do {
            //let artistId = Int64(abs(user.id.uuidString.hashValue))
            let artistId = user.id.uuidString
            let response: [Song] = try await SupabaseService.shared.client
                .from("songs")
                .select("*")
                .eq("artist_id", value: artistId)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            await MainActor.run {
                pendingSongs = response.filter { $0.status == "pending" }
                approvedSongs = response.filter { $0.status == "approved" }
                rejectedSongs = response.filter { $0.status == "rejected" }
                
                totalStreams = response.reduce(0) { $0 + ($1.play_count ?? 0) }
                totalRevenue = Double(totalStreams) * 0.004
                
                isLoading = false
            }
        } catch {
            print("Fetch error:", error)
            isLoading = false
        }
    }
}

// MARK: - Supporting Views
struct ArtistAnalyticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon).font(.system(size: 28)).foregroundColor(color)
            Text(value).font(.title.bold()).foregroundColor(.white)
            Text(title).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.06)))
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
        case "approved": return .green
        case "pending": return .yellow
        case "rejected": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                image.resizable().scaledToFill()
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
                    Button("Edit") {}
                    Button("Delete", role: .destructive) {}
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.06)))
    }
}

// MARK: - Upload View (Multiple Songs)
struct UploadSongView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var songs: [SongUploadItem] = [SongUploadItem()]
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    
    let genres = ["Pop", "Rock", "Hip Hop", "EDM", "Jazz", "Lo-fi"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Upload Multiple Songs")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    ForEach($songs) { $song in
                        SongUploadRow(
                            song: $song,
                            genres: genres,
                            onDelete: {
                                if songs.count > 1 {
                                    songs.removeAll { $0.id == song.id }
                                }
                            }
                        )
                    }
                    
                    Button {
                        songs.append(SongUploadItem())
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Another Song")
                        }
                        .foregroundColor(.cyan)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    Button {
                        Task { await uploadAllSongs() }
                    } label: {
                        if isUploading {
                            ProgressView(value: uploadProgress)
                                .progressViewStyle(.linear)
                                .tint(.cyan)
                        } else {
                            Text("Submit All Songs for Approval")
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .disabled(isUploading)
                }
                .padding()
            }
        }
    }
    
    func uploadAllSongs() async {
        guard let user = SupabaseService.shared.client.auth.currentUser else { return }
        
        isUploading = true
        uploadProgress = 0.0
        let total = songs.count
        var uploadedCount = 0
        
        let artistId = Int64(abs(user.id.uuidString.hashValue))
        
        for songItem in songs {
            guard !songItem.title.isEmpty, !songItem.audioURL.isEmpty else { continue }
            
            do {
                let newSong = SongInsert(
                    title: songItem.title,
                    image_url: songItem.imageURL,
                    audio_url: songItem.audioURL,
                    genre: songItem.genre,
                    lyrics: songItem.lyrics,
                    artist_id: artistId,
                    is_premium: songItem.isPremium,
                    is_explicit: songItem.isExplicit,
                    status: "pending"
                )
                
                try await SupabaseService.shared.client
                    .from("songs")
                    .insert(newSong)
                    .execute()
                
                uploadedCount += 1
                uploadProgress = Double(uploadedCount) / Double(total)
                
            } catch {
                print("Failed to upload \(songItem.title):", error)
            }
        }
        
        await MainActor.run {
            isUploading = false
            dismiss()
        }
    }
}

struct SongUploadRow: View {
    @Binding var song: SongUploadItem
    let genres: [String]
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Song \(song.title.isEmpty ? "" : "- \(song.title)")")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                }
            }
            
            TextField("Song Title *", text: $song.title)
                .artistField()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("MP3 Audio URL").foregroundColor(.gray)
                TextField("Audio URL", text: $song.audioURL)
                    .artistField()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Cover Image URL").foregroundColor(.gray)
                TextField("Cover Image URL", text: $song.imageURL)
                    .artistField()
            }
            
            Picker("Genre", selection: $song.genre) {
                ForEach(genres, id: \.self) { Text($0) }
            }
            .pickerStyle(.menu)
            .tint(.white)
            
            Toggle("Premium Song", isOn: $song.isPremium)
                .foregroundColor(.white)
            Toggle("Explicit Content", isOn: $song.isExplicit)
                .foregroundColor(.white)
            
            TextEditor(text: $song.lyrics)
                .frame(height: 120)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Extension
extension View {
    func artistField() -> some View {
        self
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .foregroundColor(.white)
    }
}
