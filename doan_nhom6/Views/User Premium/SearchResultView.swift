//
//  SearchResultView.swift.swift
//  doan_nhom6
//
//  Created by macbook on 16/5/26.
//

import Foundation
import SwiftUI

struct SearchResultView: View {

    let searchText: String
    let songs: [Song]
    let allSongs: [Song]

    var body: some View {

        ZStack {

            AnimatedBackgroundView()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    Text("Search Result")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    if searchText.isEmpty {

                        Text("Start searching...")
                            .foregroundColor(.gray)

                    } else if songs.isEmpty {

                        VStack(spacing: 16) {

                            Image(systemName: "music.note.list")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)

                            Text("No songs found")
                                .foregroundColor(.white)
                                .font(.title3.bold())

                            Text("Try another keyword")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)

                    } else {

                        LazyVStack(spacing: 14) {

                            ForEach(songs) { song in

                                NavigationLink {

                                    PlayerRouterView(
                                        song: song,
                                        songs: allSongs
                                    )

                                } label: {

                                    SongCard(song: song)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
}
