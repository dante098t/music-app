//
//  Analytics.swift
//  doan_nhom6
//
//  Created by macbook on 14/5/26.
//

import Foundation
import Foundation

struct Analytics: Codable, Identifiable {

    let id: UUID

    let song_id: Int

    let total_plays: Int

    let total_downloads: Int

    let total_favorites: Int
}
