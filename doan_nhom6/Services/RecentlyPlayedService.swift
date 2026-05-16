//
//  RecentlyPlayedService.swift
//  doan_nhom6
//
//  Created by macbook on 14/5/26.
//

import Foundation
import Foundation
import Supabase
struct RecentlyPlayedInsert: Encodable {

    let user_id: String
    let song_id: Int
}
final class RecentlyPlayedService {

    static let shared =
    RecentlyPlayedService()

    private let client =
    SupabaseService.shared.client

    private init() {}

    // MARK: SAVE

    func saveSong(
        userId: UUID,
        songId: Int
    ) async {

        do {

            try await client

                .from("recently_played")

                .insert(

                    RecentlyPlayedInsert(

                        user_id: userId.uuidString,

                        song_id: songId

                    )

                )

                .execute()

        } catch {

            print(error)
        }
    }

    // MARK: FETCH

    func fetchRecentlyPlayed(
        userId: UUID
    ) async throws -> [Song] {

        let items: [RecentlyPlayed] =
        try await client

            .from("recently_played")

            .select("""
            *,
            song:songs(
                *,
                artist:artists(*),
                album:albums(*)
            )
            """)

            .eq("user_id", value: userId.uuidString)

            .order(
                "played_at",
                ascending: false
            )

            .limit(20)

            .execute()

            .value

        return items.compactMap {
            $0.song
        }
    }
}
