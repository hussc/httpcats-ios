//
//  HTTPCatItem.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import Foundation

struct HTTPCat: Codable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}

typealias HTTPCats = [HTTPCat]

