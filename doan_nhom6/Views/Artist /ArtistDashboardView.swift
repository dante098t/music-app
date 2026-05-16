import SwiftUI

struct ArtistDashboardView: View {
    
    // MARK: MOCK DATA
    
    let totalRevenue: Double = 12840
    let totalStreams: Int = 842300
    let monthlyListeners: Int = 125400
    let totalAlbums: Int = 6
    let pendingApprovals: Int = 3
    
    // MARK: SONG DATA
    
    let topSongs: [ArtistSongStat] = [
        .init(title: "Midnight Rain", streams: 240000, revenue: 3200),
        .init(title: "Neon Dream", streams: 198000, revenue: 2510),
        .init(title: "Echo Heart", streams: 144000, revenue: 1800)
    ]
    
    // MARK: ALBUM DATA
    
    let albums: [ArtistAlbumStat] = [
        .init(title: "Cyber Love", streams: 420000, revenue: 5400),
        .init(title: "Lost Signals", streams: 260000, revenue: 3100),
        .init(title: "After Midnight", streams: 162000, revenue: 2200)
    ]
    
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
                        
                        // MARK: HEADER
                        
                        VStack(spacing: 10) {
                            
                            Image(systemName: "music.mic.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.cyan)
                                .shadow(color: .cyan.opacity(0.6), radius: 12)
                            
                            Text("Artist Dashboard")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Manage your music and analytics")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // MARK: ANALYTICS
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            
                            DashboardCard(
                                title: "Revenue",
                                value: "$\(Int(totalRevenue))",
                                icon: "dollarsign.circle.fill",
                                color: .green
                            )
                            
                            DashboardCard(
                                title: "Streams",
                                value: "\(totalStreams)",
                                icon: "waveform",
                                color: .cyan
                            )
                            
                            DashboardCard(
                                title: "Listeners",
                                value: "\(monthlyListeners)",
                                icon: "person.3.fill",
                                color: .orange
                            )
                            
                            DashboardCard(
                                title: "Albums",
                                value: "\(totalAlbums)",
                                icon: "rectangle.stack.fill",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                        
                        // MARK: PENDING APPROVAL
                        
                        VStack(alignment: .leading, spacing: 14) {
                            
                            HStack {
                                
                                Image(systemName: "clock.badge.exclamationmark")
                                    .foregroundColor(.yellow)
                                
                                Text("Pending Admin Approval")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(pendingApprovals)")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.bold)
                            }
                            
                            Text("New songs and albums must be approved by admin before publishing.")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.06))
                        )
                        .padding(.horizontal)
                        
                        // MARK: QUICK ACTIONS
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Quick Actions")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                            
                            HStack(spacing: 16) {
                                
                                NavigationLink {
                                    UploadSongView()
                                } label: {
                                    ActionButton(
                                        title: "Upload Song",
                                        icon: "music.note"
                                    )
                                }
                                
                                NavigationLink {
                                    UploadAlbumView()
                                } label: {
                                    ActionButton(
                                        title: "New Album",
                                        icon: "square.stack.fill"
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: TOP SONGS
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Top Songs")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                            
                            ForEach(topSongs) { song in
                                
                                SongStatRow(song: song)
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: ALBUM STATS
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Album Analytics")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                            
                            ForEach(albums) { album in
                                
                                AlbumStatRow(album: album)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

// MARK: DASHBOARD CARD

struct DashboardCard: View {
    
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
                .foregroundColor(.white)
                .font(.title.bold())
            
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

// MARK: ACTION BUTTON

struct ActionButton: View {
    
    let title: String
    let icon: String
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.cyan)
            
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.08))
        )
    }
}

// MARK: SONG ROW

struct SongStatRow: View {
    
    let song: ArtistSongStat
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            HStack {
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(song.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text("\(song.streams) streams")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Spacer()
                
                Text("$\(Int(song.revenue))")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
            
            ProgressView(value: Double(song.streams), total: 300000)
                .tint(.cyan)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: ALBUM ROW

struct AlbumStatRow: View {
    
    let album: ArtistAlbumStat
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(album.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("\(album.streams) streams")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            Text("$\(Int(album.revenue))")
                .foregroundColor(.cyan)
                .fontWeight(.bold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: UPLOAD SONG VIEW

struct UploadSongView: View {
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            Text("Upload New Song")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
        }
    }
}

// MARK: UPLOAD ALBUM VIEW

struct UploadAlbumView: View {
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            Text("Create New Album")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
        }
    }
}

// MARK: MODELS

struct ArtistSongStat: Identifiable {
    
    let id = UUID()
    
    let title: String
    let streams: Int
    let revenue: Double
}

struct ArtistAlbumStat: Identifiable {
    
    let id = UUID()
    
    let title: String
    let streams: Int
    let revenue: Double
}
