//
//  Model.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation

struct Model: Decodable {
    
    var success:Bool
    var data: [Animes]
    
}

struct Animes: Decodable {
    
    var animeId: Int
    var animeName: String
    var animeImg: String
    
    enum CodingKeys: String, CodingKey{
        case animeId = "anime_id"
        case animeName = "anime_name"
        case animeImg = "anime_img"
    }
}
