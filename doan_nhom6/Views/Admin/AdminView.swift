import SwiftUI
import Supabase

struct AdminView: View {

    // MARK: - VIEW MODEL
    @StateObject private var viewModel = AdminViewModel()

    // MARK: - STATE
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // HEADER
                    headerSection
                    
                    // TABS
                    tabSection
                    
                    // CONTENT
                    TabView(selection: $selectedTab) {
                        songsSection
                            .tag(0)
                        
                        reportsSection
                            .tag(1)
                        
                        pendingSongsSection
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .preferredColorScheme(.dark)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.4))
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task {
                await viewModel.loadAll()   // Load tất cả dữ liệu
            }
        }
    }
}

// MARK: - EXTENSION
extension AdminView {

    // MARK: HEADER
    var headerSection: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Admin Dashboard")
                        .font(.largeTitle.bold())
                    Text("Manage platform")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "crown.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }

    // MARK: TABS
    var tabSection: some View {
        HStack(spacing: 14) {
            adminTab(title: "Songs", index: 0, icon: "music.note")
            adminTab(title: "Reports", index: 1, icon: "exclamationmark.bubble")
            adminTab(title: "Pending", index: 2, icon: "clock.fill")
        }
        .padding()
    }

    // MARK: SONGS SECTION
    var songsSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                NavigationLink {
                    AddSongView()
                } label: {
                    addSongCard
                }

                ForEach(viewModel.songs) { song in
                    songRow(song)
                }
            }
            .padding()
        }
    }

    var reportsSection: some View {
        
        ScrollView(showsIndicators: false) {
            
            LazyVStack(spacing: 16) {
                
                ForEach(viewModel.reports, id: \.id) { report in
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack {
                            
                            Text(
                                report.reason
                                ?? "Unknown reason"
                            )
                            .font(.headline)
                            
                            Spacer()
                            
                            Text(
                                (report.status ?? "unknown")
                                    .uppercased()
                            )
                            .font(.caption.bold())
                            .foregroundColor(
                                ((report.status ?? "")
                                    .lowercased() == "resolved")
                                ? .green
                                : .pink
                            )
                        }
                        
                        Text(
                            report.description ?? ""
                        )
                        .foregroundColor(.gray)
                        
                        if let song = report.song {
                            
                            Text(
                                "Song: \(song.title ?? "Unknown")"
                            )
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        }
                        
                        HStack(spacing: 12) {
                            
                            Button {
                                
                                Task {
                                    
                                    await viewModel
                                        .resolveReport(report)
                                }
                                
                            } label: {
                                
                                Text("Resolve")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.green)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 16
                                        )
                                    )
                            }
                            
                            Button(
                                role: .destructive
                            ) {
                                
                                print("Delete Report")
                                
                            } label: {
                                
                                Text("Delete")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.red)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 16
                                        )
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(
                        Color.white.opacity(0.06)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 22
                        )
                    )
                }
            }
            .padding()
        }
    }
    // MARK: PENDING SONGS SECTION
    var pendingSongsSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.pendingSongsList) { song in  // ← Sửa thành pendingSongsList
                    VStack(spacing: 14) {
                        songRow(song)

                        HStack(spacing: 12) {
                            Button {
                                Task {
                                    await viewModel.approveSong(song)
                                }
                            } label: {
                                Text("Approve")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.green)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }

                            Button {
                                Task {
                                    await viewModel.rejectSong(song)
                                }
                            } label: {
                                Text("Reject")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    // MARK: SONG ROW
    func songRow(_ song: Song) -> some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                VStack(alignment: .leading, spacing: 5) {
                    Text(song.title ?? "")
                        .font(.headline)

                    Text(song.artist?.name ?? "")
                        .foregroundColor(.gray)

                    HStack(spacing: 10) {
                        Text(song.genre ?? "Unknown")
                            .font(.caption)
                        if song.is_explicit == true {
                            Text("Explicit")
                                .font(.caption.bold())
                                .foregroundColor(.red)
                        }
                    }
                }

                Spacer()
            }

            HStack {
                NavigationLink {
                    EditSongView(song: song)
                } label: {
                    adminActionButton(title: "Edit", color: .blue)
                }

                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteSong(song)
                    }
                } label: {
                    adminActionButton(title: "Delete", color: .red)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }

    // MARK: ADD SONG CARD
    var addSongCard: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 34))
                .foregroundColor(.pink)

            VStack(alignment: .leading, spacing: 4) {
                Text("Add New Song")
                    .font(.headline)
                Text("Upload music & manage metadata")
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.pink.opacity(0.35), .purple.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }

    // MARK: TAB BUTTON
    func adminTab(title: String, index: Int, icon: String) -> some View {
        Button {
            withAnimation {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundColor(selectedTab == index ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                selectedTab == index ? Color.white.opacity(0.12) : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    // MARK: ACTION BUTTON
    func adminActionButton(title: String, color: Color) -> some View {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
import SwiftUI
import PhotosUI
import SwiftUI
import PhotosUI

struct AddSongView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AdminViewModel()
    
    // MARK: - Form
    @State private var title = ""
    @State private var genre = ""
    @State private var lyrics = ""
    
    @State private var selectedArtist: Artist?
    @State private var isPremium = false
    @State private var isExplicit = false
    
    // MARK: - Media
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var audioURL: URL?
    
    @State private var isUploading = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Cover Image
                    VStack(spacing: 12) {
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                        } else {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.gray.opacity(0.15))
                                .frame(width: 180, height: 180)
                                .overlay {
                                    Image(systemName: "photo")
                                        .font(.system(size: 42))
                                        .foregroundColor(.gray)
                                }
                        }
                        
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Text("Upload Cover")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    // Title, Genre, Artist, Lyrics... (giữ nguyên)
                    VStack(alignment: .leading) {
                        Text("Song Title").font(.headline)
                        TextField("Enter title", text: $title)
                            .padding().background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Genre").font(.headline)
                        TextField("Pop / Rap / EDM", text: $genre)
                            .padding().background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Artist").font(.headline)
                        Menu {
                            ForEach(viewModel.artists) { artist in
                                Button {
                                    selectedArtist = artist
                                } label: {
                                    Text(artist.name ?? "")
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedArtist?.name ?? "Select Artist")
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Lyrics").font(.headline)
                        TextEditor(text: $lyrics)
                            .frame(height: 180)
                            .padding(8)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(spacing: 18) {
                        Toggle("Premium Only", isOn: $isPremium)
                        Toggle("Explicit Content", isOn: $isExplicit)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    // Audio Button
                    Button {
                        pickAudio()
                    } label: {
                        HStack {
                            Image(systemName: "music.note")
                            Text(audioURL == nil ? "Upload Audio" : "Audio Selected")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // Save Button
                    Button {
                        Task { await uploadSong() }
                    } label: {
                        if isUploading {
                            ProgressView()
                        } else {
                            Text("Create Song")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .disabled(isUploading || selectedArtist == nil || title.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Add New Song")
            .task {
                await viewModel.fetchArtists()
            }
        }
        .onChange(of: selectedImage) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
    
    func pickAudio() {
        // TODO: Implement DocumentPicker or FileImporter
        print("🎵 Audio picker - Chưa triển khai")
    }
    
    func uploadSong() async {
        guard let artist = selectedArtist, !title.isEmpty else { return }
        isUploading = true
        defer { isUploading = false }
        struct NewSongPayload: Encodable {
            let title: String
            let genre: String
            let lyrics: String
            let image_url: String
            let audio_url: String
            let artist_id: Int64
            let is_premium: Bool
            let is_explicit: Bool
            let status: String
        }
        do {
            // TODO: Upload image & audio to Supabase Storage trước
            let imageURL = "https://placeholder.com/image.jpg"
            let audioURLString = "https://placeholder.com/audio.mp3"
            let payload = NewSongPayload(
                title: title,
                genre: genre,
                lyrics: lyrics,
                image_url: imageURL,
                audio_url: audioURLString,
                artist_id: artist.id,
                is_premium: isPremium,
                is_explicit: isExplicit,
                status: "pending"
            )
            try await SupabaseService.shared.client
                .from("songs")
                .insert(payload)
                .execute()
            print("✅ Song created successfully")
            dismiss()
        } catch {
            print("❌ Upload error:", error)
        }
    }
}
import SwiftUI

struct EditSongView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AdminViewModel()
    
    let song: Song
    
    @State private var title = ""
    @State private var genre = ""
    @State private var lyrics = ""
    @State private var isPremium = false
    @State private var isExplicit = false
    @State private var selectedArtist: Artist?
    
    @State private var isSaving = false
    
    init(song: Song) {
        self.song = song
        _title = State(initialValue: song.title ?? "")
        _genre = State(initialValue: song.genre ?? "")
        _lyrics = State(initialValue: song.lyrics ?? "")
        _isPremium = State(initialValue: song.is_premium ?? false)
        _isExplicit = State(initialValue: song.is_explicit ?? false)
        _selectedArtist = State(initialValue: song.artist)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Cover
                    AsyncImage(url: URL(string: song.image_url ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                    // Title, Genre, Artist, Lyrics... (giữ nguyên)
                    
                    VStack(alignment: .leading) {
                        Text("Song Title").font(.headline)
                        TextField("Title", text: $title)
                            .padding().background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Genre").font(.headline)
                        TextField("Genre", text: $genre)
                            .padding().background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Artist").font(.headline)
                        Menu {
                            ForEach(viewModel.artists) { artist in
                                Button {
                                    selectedArtist = artist
                                } label: {
                                    Text(artist.name ?? "")
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedArtist?.name ?? "Select Artist")
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Lyrics").font(.headline)
                        TextEditor(text: $lyrics)
                            .frame(height: 220)
                            .padding(8)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    VStack(spacing: 18) {
                        Toggle("Premium Song", isOn: $isPremium)
                        Toggle("Explicit Content", isOn: $isExplicit)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Button {
                        Task { await saveSong() }
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Changes")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding()
            }
            .navigationTitle("Edit Song")
            .task {
                await viewModel.fetchArtists()
            }
        }
    }
    
    func saveSong() async {
        guard let artist = selectedArtist else { return }
        
        isSaving = true
        defer { isSaving = false }
        
        do {
            struct UpdateSongPayload: Encodable {
                let title: String
                let genre: String
                let lyrics: String
                let artist_id: Int64
                let is_premium: Bool
                let is_explicit: Bool
            }
            let payload = UpdateSongPayload(
                title: title,
                genre: genre,
                lyrics: lyrics,
                artist_id: artist.id,
                is_premium: isPremium,
                is_explicit: isExplicit
            )
            try await SupabaseService.shared.client
                .from("songs")
                .update(payload)
                .eq("id", value: String(song.id))
                .execute()
            print("✅ Song updated")
            dismiss()
            
        } catch {
            print("❌ Update error:", error)
        }
    }
}


