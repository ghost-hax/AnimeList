//
//  MockNetwork.swift
//  APICallTests
//
//  Created by David on 09/03/2022.
//

import Foundation

@testable import APICall
import Combine

class MockNetworkManager: NetworkManagerType {
    func apiCall<T>(apiRequest: ApiRequestType, type: T.Type) -> Future<T, ServiceError> where T : Decodable {
        
        return Future { promise in
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.path, withExtension:"json"),
                  let data = //try? Data(contentsOf: url)
                    try? T(from: url as! Decoder)
//                      try? JSONDecoder().decode(T.self, from: url)

            else {
                promise(.failure(ServiceError.dataNotFound))
          
                return
            }
            promise(.success(data))
        }
    }
    
    func preIOS13ApiCall<T>(_ apiRequest: ApiRequestType, type: T.Type, completionHandler: @escaping (Result<T, ServiceError>) -> Void) where T : Decodable {
       
        let bundle = Bundle(for:MockNetworkManager.self)
        
        guard let url = bundle.url(forResource:apiRequest.path, withExtension:"json"),
              let data = try? Data(contentsOf: url) else {
                  completionHandler(.failure(ServiceError.serviceNotAvailable))

                  return
              }
        
        do {
            let decodedResopnce = try JSONDecoder().decode(T.self, from: data)
            completionHandler(.success(decodedResopnce))
            
        }catch {
            completionHandler(.failure(ServiceError.parsingFailed))
        }
        
    }
    
}
