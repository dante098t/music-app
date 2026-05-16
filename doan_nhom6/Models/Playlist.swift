//
//  Playlist.swift
//  doan_nhom6
//
//  Created by macbook on 7/5/26.
//

import Foundation
struct Playlist: Codable, Identifiable {

    let id: UUID

    let user_id: UUID

    let title: String

    let cover_url: String?

    let is_public: Bool

    let created_at: String?
}
