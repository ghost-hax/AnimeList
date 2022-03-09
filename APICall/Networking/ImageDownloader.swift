//
//  ImageDownloader.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import UIKit

protocol ImageDownLoaderType {
    func getImage(url:String, completion:@escaping (Data)->Void)
}

protocol ImageCacherType {
    func getImage(url:String)-> Data?
    func saveImage(url:String, data:Data)
}

class ImageCacher:ImageCacherType {
    static let shared = ImageCacher()
    var cache = NSCache<NSString, NSData>()

    private init(){
       // cache.countLimit = 100
    }
    
    func getImage(url: String) -> Data? {
        return cache.object(forKey: url as NSString) as Data?
    }
    
    func saveImage(url: String, data: Data) {
        cache.setObject(data as NSData, forKey: url as NSString)
    }
}

class ImageDownloader:ImageDownLoaderType {

    static let shared = ImageDownloader()
    private init() {}

    func getImage(url: String, completion:@escaping (Data) -> Void) {
        
        let imageCacher = ImageCacher.shared
        
        if let image = imageCacher.getImage(url: url) {
            completion(image)
        }else {
            dowloadImage(url: url) { imageData in
                imageCacher.saveImage(url: url, data:imageData )
                completion(imageData)
            }
        }
    }

    private func dowloadImage(url:String, completion:@escaping (Data)->Void) {

        guard let _url = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: _url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }

              completion(data)
        }.resume()

    }
}


