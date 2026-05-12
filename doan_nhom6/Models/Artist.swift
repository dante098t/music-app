//
//  Artist.swift
//  doan_nhom6
//
//  Created by macbook on 12/5/26.
//

import Foundation
import Foundation

struct Artist: Identifiable, Codable, Equatable {

    let id: Int64

    let name: String

    let avatar_url: String?

    let bio: String?

}
