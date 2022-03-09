//
//  Networking.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import Combine

enum ServiceError: Error {
    case serviceNotAvailable
    case parsingFailed
    case requestNotFormatted
    case failedToCreateRequest
    case dataNotFound
    case unknown
}

protocol Networkable {
    @available(iOS 13.0, *)
    func doApiCall<T:Decodable>(apiRequest:ApiRequestType, type:T.Type)-> Future<T, ServiceError>
    func get<T:Decodable>(_ apiRequest:ApiRequestType, type:T.Type, completionHandler:@escaping(Result<T, ServiceError>)->Void)
}

class Networking:NSObject, Networkable {
    
    func doApiCall<T:Decodable>(apiRequest: ApiRequestType, type:T.Type) -> Future<T, ServiceError> {
        
        return Future { promise in
            
            // URLSessonDataTask
            let urlSession = URLSession.shared
            guard let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)) else {
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
    
    func get<T>(_ apiRequest: ApiRequestType, type: T.Type, completionHandler: @escaping (Result<T, ServiceError>) -> Void) where T : Decodable {
        
        // URLSessonDataTask
        let urlSession = URLSession.shared
        guard let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)) else {
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

extension Networking:URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust =  challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        guard  let serverCertificate = SecTrustCopyCertificateChain(serverTrust) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let serrverCertificateData:NSData = SecCertificateCopyData(serverCertificate as! SecCertificate)//changing type into NSData
        
        
        guard let path  = Bundle.main.path(forResource:"google", ofType:"cer") else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
       let localSertificate =  NSData(contentsOfFile: path)//changing type into NSData
        
        if serrverCertificateData.isEqual(to: localSertificate as! Data) {
            completionHandler(.useCredential, nil)
        }else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
