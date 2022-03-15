//
//  Networking.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import Combine

protocol NetworkManagerType {
    @available(iOS 13.0, *)
    func apiCall<T:Decodable>(apiRequest:ApiRequestType, type:T.Type)-> Future<T, ServiceError>
    func preIOS13ApiCall<T:Decodable>(_ apiRequest:ApiRequestType, type:T.Type, completionHandler:@escaping(Result<T, ServiceError>)->Void)
}

class NetworkManager:NSObject, NetworkManagerType {
    
    func apiCall<T:Decodable>(apiRequest: ApiRequestType, type:T.Type) -> Future<T, ServiceError> {
        
        return Future { promise in
            
            // URLSessonDataTask
            let urlSession = URLSession.shared
            guard let url = URL(string:apiRequest.baseUrl) else {
                promise(.failure(ServiceError.requestNotFormatted))
                print("url path error")
                return
            }
            let dataTask = urlSession.dataTask(with: url) { data, urlResponse, error in
                
                guard let _data = data else {
                    promise(.failure(ServiceError.serviceNotAvailable))
                    print(String(describing: error?.localizedDescription))
                    return
                }
                let decoder = JSONDecoder()
                
                do {
                    let users =  try decoder.decode(T.self, from: _data)
                    promise(.success(users))
                }catch {
                    promise(.failure(ServiceError.parsingFailed))
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }
    }

    
    // MARK: - for Older iOS versions (Pre iOS 13)
    func preIOS13ApiCall<T>(_ apiRequest: ApiRequestType, type: T.Type, completionHandler: @escaping (Result<T, ServiceError>) -> Void) where T : Decodable {
        
        // URLSessonDataTask
        let urlSession = URLSession.shared
        guard let url = URL(string:apiRequest.baseUrl) else {
            completionHandler(.failure(ServiceError.requestNotFormatted))
            return
        }
        let dataTask = urlSession.dataTask(with: url) { data, urlResponse, error in
            
            guard let _data = data else {
                completionHandler(.failure(ServiceError.serviceNotAvailable))
                return
            }
            do {
                let users =  try JSONDecoder().decode(T.self, from: _data)
                completionHandler(.success(users))
            }catch {
                completionHandler(.failure(ServiceError.parsingFailed))
            }
        }
        dataTask.resume()
    }
    
}


enum ServiceError: Error {
    case serviceNotAvailable
    case parsingFailed
    case requestNotFormatted
    case failedToCreateRequest
    case dataNotFound
    case unknown
}
