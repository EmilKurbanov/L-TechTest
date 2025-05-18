//
//  PostModel.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Foundation
struct Post: Codable {
    let id: Int?
    let title: String
    let text: String
    let image: String
    let sort: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case id, title, text, image, sort, date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intId = try? container.decodeIfPresent(Int.self, forKey: .id) {
            id = intId
        } else if let stringId = try? container.decodeIfPresent(String.self, forKey: .id),
                  let intIdFromString = Int(stringId) {
            id = intIdFromString
        } else {
            id = nil
        }

        title = try container.decode(String.self, forKey: .title)
        text = try container.decode(String.self, forKey: .text)
        image = try container.decode(String.self, forKey: .image)
        sort = try container.decode(Int.self, forKey: .sort)
        date = try container.decode(String.self, forKey: .date)
    }
}

