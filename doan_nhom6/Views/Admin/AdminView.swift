import SwiftUI
import Charts

struct AdminView: View {
    
    // MARK: MOCK DATA
    
    let totalUsers = 124_820
    let totalArtists = 432
    let totalSongs = 8_942
    let totalAlbums = 1_203
    
    let pendingSongs = 12
    let pendingAlbums = 4
    let reportedContents = 7
    
    let revenue: [RevenueData] = [
        .init(month: "Jan", value: 1200),
        .init(month: "Feb", value: 1800),
        .init(month: "Mar", value: 2400),
        .init(month: "Apr", value: 3200),
        .init(month: "May", value: 4100),
        .init(month: "Jun", value: 5300)
    ]
    
    let topSongs: [TopSong] = [
        .init(name: "Blinding Lights", streams: "2.1M"),
        .init(name: "Save Your Tears", streams: "1.7M"),
        .init(name: "Starboy", streams: "1.4M")
    ]
    
    let pendingApprovals: [PendingItem] = [
        .init(title: "New Album - Midnight Dreams", type: "Album"),
        .init(title: "Song - Lost In Tokyo", type: "Song"),
        .init(title: "Song - Neon Hearts", type: "Song")
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                LinearGradient(
                    colors: [
                        .black,
                        Color.blue.opacity(0.25),
                        .black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 22) {
                        
                        // MARK: HEADER
                        
                        VStack(spacing: 8) {
                            
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.system(size: 54))
                                .foregroundColor(.cyan)
                            
                            Text("Admin Dashboard")
                                .font(
                                    .system(
                                        size: 34,
                                        weight: .bold
                                    )
                                )
                                .foregroundColor(.white)
                            
                            Text("System Management Panel")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // MARK: OVERVIEW
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 18
                        ) {
                            
                            DashboardCard(
                                title: "Users",
                                value: "\(totalUsers)",
                                icon: "person.3.fill",
                                color: .cyan
                            )
                            
                            DashboardCard(
                                title: "Artists",
                                value: "\(totalArtists)",
                                icon: "music.mic",
                                color: .purple
                            )
                            
                            DashboardCard(
                                title: "Songs",
                                value: "\(totalSongs)",
                                icon: "music.note",
                                color: .green
                            )
                            
                            DashboardCard(
                                title: "Albums",
                                value: "\(totalAlbums)",
                                icon: "square.stack.fill",
                                color: .orange
                            )
                        }
                        
                        // MARK: REVENUE
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            HStack {
                                
                                Text("Revenue Analytics")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.green)
                            }
                            
                            Chart(revenue) { item in
                                
                                LineMark(
                                    x: .value(
                                        "Month",
                                        item.month
                                    ),
                                    y: .value(
                                        "Revenue",
                                        item.value
                                    )
                                )
                                
                                AreaMark(
                                    x: .value(
                                        "Month",
                                        item.month
                                    ),
                                    y: .value(
                                        "Revenue",
                                        item.value
                                    )
                                )
                            }
                            .frame(height: 220)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(
                                cornerRadius: 28
                            )
                            .fill(Color.white.opacity(0.06))
                        )
                        
                        // MARK: APPROVALS
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            HStack {
                                
                                Text("Pending Approvals")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(
                                    "\(pendingSongs + pendingAlbums)"
                                )
                                .foregroundColor(.yellow)
                                .font(.headline)
                            }
                            
                            ForEach(pendingApprovals) { item in
                                
                                HStack {
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 4
                                    ) {
                                        
                                        Text(item.title)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                        
                                        Text(item.type)
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 10) {
                                        
                                        Button {
                                            
                                        } label: {
                                            
                                            Image(
                                                systemName:
                                                    "checkmark"
                                            )
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .background(.green)
                                            .clipShape(Circle())
                                        }
                                        
                                        Button {
                                            
                                        } label: {
                                            
                                            Image(
                                                systemName:
                                                    "xmark"
                                            )
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(.red)
                                            .clipShape(Circle())
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(
                                        cornerRadius: 18
                                    )
                                    .fill(
                                        Color.white.opacity(0.05)
                                    )
                                )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(
                                cornerRadius: 28
                            )
                            .fill(Color.white.opacity(0.06))
                        )
                        
                        // MARK: TOP SONGS
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            HStack {
                                
                                Text("Top Streaming Songs")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                            }
                            
                            ForEach(topSongs) { song in
                                
                                HStack {
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 4
                                    ) {
                                        
                                        Text(song.name)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                        
                                        Text(
                                            "\(song.streams) streams"
                                        )
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(
                                        systemName:
                                            "waveform"
                                    )
                                    .foregroundColor(.cyan)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(
                                        cornerRadius: 18
                                    )
                                    .fill(
                                        Color.white.opacity(0.05)
                                    )
                                )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(
                                cornerRadius: 28
                            )
                            .fill(Color.white.opacity(0.06))
                        )
                        
                        // MARK: REPORTS
                        
                        HStack(spacing: 18) {
                            
                            SmallStatusCard(
                                title: "Reports",
                                value: "\(reportedContents)",
                                icon: "exclamationmark.triangle.fill",
                                color: .red
                            )
                            
                            SmallStatusCard(
                                title: "Pending Songs",
                                value: "\(pendingSongs)",
                                icon: "music.note.list",
                                color: .yellow
                            )
                            
                            SmallStatusCard(
                                title: "Albums",
                                value: "\(pendingAlbums)",
                                icon: "square.stack.fill",
                                color: .purple
                            )
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding()
                }
            }
        }
    }
}



// MARK: SMALL STATUS CARD

struct SmallStatusCard: View {
    
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(value)
                .foregroundColor(.white)
                .font(.headline.bold())
            
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: MODELS

struct RevenueData: Identifiable {
    
    let id = UUID()
    
    let month: String
    let value: Double
}

struct TopSong: Identifiable {
    
    let id = UUID()
    
    let name: String
    let streams: String
}

struct PendingItem: Identifiable {
    
    let id = UUID()
    
    let title: String
    let type: String
}
