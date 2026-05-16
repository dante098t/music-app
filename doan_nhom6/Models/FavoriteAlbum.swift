//
//  FavoriteAlbum.swift
//  doan_nhom6
//
//  Created by macbook on 14/5/26.
//

import Foundation
import Foundation

struct FavoriteAlbum:
Codable, Identifiable {

    let id: UUID

    let user_id: UUID

    let album_id: Int

    let created_at: String?
}
