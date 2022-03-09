//
//  ApiClient.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation

protocol ApiRequestType {
    var baseUrl:String {get}
    var path:String {get}
}

struct ApiRequest: ApiRequestType {
    var baseUrl: String
    var path: String
}

struct EndPoint {
    static let baseUrl = "https://anime-facts-rest-api.herokuapp.com/api/v1"
}

struct Path {
}
