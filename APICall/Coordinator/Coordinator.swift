//
//  Coordinator.swift
//  APICall
//
//  Created by David on 15/03/2022.
//

import Foundation
import Combine

protocol CoordinatorType{
    
    var stateBinding: Published<ViewState>.Publisher { get }
    var animeList:AnimeList? { get }
    var animeListCount:Int { get }
    
    func getRequest<T:Decodable>(apiRequest: ApiRequestType, type:T.Type)
    func preIOS13GetRequest<T:Decodable>(apiRequest:ApiRequestType, type:T.Type, completionHandler:@escaping(Result<T, ServiceError>)->Void)
    
}

class Coordinator: CoordinatorType{
    
    var stateBinding: Published<ViewState>.Publisher{ $loadingState }
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var loadingState: ViewState = .none
    var animeListCount:Int {
        guard let dataCount = animeList?.data.count else { return 0 }
        return dataCount
    }
    
    private var networkManager: NetworkManagerType
    private weak var delegate: AnimeListViewModelType?
    
    var animeList:AnimeList?
    
    init(networkManager:NetworkManagerType = NetworkManager(), delegate:AnimeListViewModelType) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func getRequest<T:Decodable>(apiRequest: ApiRequestType, type:T.Type) {
        
        let publisher = networkManager.apiCall(apiRequest: apiRequest, type: type)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.loadingState = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] received in
            self?.animeList = received as? AnimeList
            self?.loadingState = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    // MARK: - for Older iOS versions (Pre iOS 13)
    func preIOS13GetRequest<T:Decodable>(apiRequest: ApiRequestType, type: T.Type, completionHandler: @escaping (Result<T, ServiceError>) -> Void){
        
        networkManager.preIOS13ApiCall(apiRequest, type: type) {[weak self] result in
            switch result {
                case .success(let data) :
                    self?.animeList = data as? AnimeList
                    self?.delegate?.refreshUI()
                case .failure(_) :
                    self?.delegate?.showError()
            }
        }
        
    }
    
}
