//
//  AnalyticsService.swift
//  doan_nhom6
//
//  Created by macbook on 14/5/26.
//

import Foundation
import Supabase

final class AnalyticsService {

    static let shared =
    AnalyticsService()

    private let client =
    SupabaseService.shared.client

    private init() {}

    // MARK: INCREASE PLAY COUNT

    func incrementPlayCount(
        songId: Int
    ) async {

        do {

            let analytics: [Analytics] =
            try await client

                .from("analytics")

                .select("*")

                .eq("song_id", value: songId)

                .execute()

                .value

            if let item = analytics.first {

                try await client

                    .from("analytics")

                    .update([
                        "total_plays":
                            item.total_plays + 1
                    ])

                    .eq("id", value: item.id.uuidString)

                    .execute()

            } else {

                try await client

                    .from("analytics")

                    .insert([
                        "song_id": songId,
                        "total_plays": 1,
                        "total_downloads": 0,
                        "total_favorites": 0
                    ])

                    .execute()
            }

        } catch {

            print(error)
        }
    }

    // MARK: FAVORITE COUNT

    func incrementFavoriteCount(
        songId: Int
    ) async {

        do {

            let analytics: [Analytics] =
            try await client

                .from("analytics")

                .select("*")

                .eq("song_id", value: songId)

                .execute()

                .value

            guard let item = analytics.first
            else { return }

            try await client

                .from("analytics")

                .update([
                    "total_favorites":
                        item.total_favorites + 1
                ])

                .eq("id", value: item.id.uuidString)

                .execute()

        } catch {

            print(error)
        }
    }
}
