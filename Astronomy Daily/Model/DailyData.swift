//
//  DailyData.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/24/22.
//

import Foundation

class DailyData: Codable {
    var title: String
    var url: String
    var explanation: String
    var date: String
    var media_type: String
    var copyright: String?
    var author: String?
    var imageData: Data?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright) ?? ""
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.explanation = try container.decode(String.self, forKey: .explanation)
        self.date = try container.decode(String.self, forKey: .date)
        self.media_type = try container.decode(String.self, forKey: .media_type)
        self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
    }
    
    init(title: String,
                     url: String,
                     explanation: String,
                     date: String,
                     media_type: String,
                     copyright: String?,
                     author: String?,
                     imageData: Data?) {
        self.title = title
        self.url = url
        self.explanation = explanation
        self.date = date
        self.copyright = copyright
        self.author = author
        self.imageData = imageData
        self.media_type = media_type
    }
    
    var description: String {
        return "title: \(title)\r\nurl: \(url)\r\nmedia_type: \(media_type)\r\ncopyright: \(copyright ?? "--")\r\nauthor: \(author ?? "--")"
    }
}

