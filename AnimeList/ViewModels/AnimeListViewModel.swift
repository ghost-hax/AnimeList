//
//  ViewModel.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import Combine

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}


protocol AnimeListViewModelType: AnyObject {
    
    var stateBinding: Published<ViewState>.Publisher { get }
    var animeList:AnimeList? { get }
    var animeListCount:Int { get }
    
    func getRequest(apiRequest: ApiRequestType)
    func preIOS13GetRequest(apiRequest: ApiRequest)
    func getDataValues(index:Int)-> AnimeValue?
}

final class AnimeListViewModel: AnimeListViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $loadingState }
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var loadingState: ViewState = .none
    
    var animeList:AnimeList?

    var animeListCount:Int {
        guard let dataCount = animeList?.data.count else { return 0 }
        return dataCount
    }
    
    private var networkManager: NetworkManagerType
    private weak var delegate: AnimeListViewType?
    
    init(networkManager:NetworkManagerType = NetworkManager(), delegate:AnimeListViewType) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func getRequest(apiRequest: ApiRequestType) {
        
        loadingState = ViewState.loading
        let publisher =   networkManager.apiCall(apiRequest: apiRequest, type:AnimeList.self)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.loadingState = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] received in
            self?.animeList = received
            self?.loadingState = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    func getDataValues(index: Int)-> AnimeValue? {
        guard index < animeListCount && index >= 0 else {
            return nil
        }
        
        guard let dataModel = animeList?.data[index]
        else { return AnimeValue(   animeId: "",
                                    animeName:"",
                                    animeImg: "")}
        
        return AnimeValue(animeId: "\(dataModel.animeId)" ,
                          animeName: dataModel.animeName ,
                          animeImg: dataModel.animeImg )
        
    }
    
    // MARK: - for Older iOS versions (Pre iOS 13)
        func preIOS13GetRequest(apiRequest: ApiRequest) {
            
            networkManager.preIOS13ApiCall(apiRequest, type: AnimeList.self) {[weak self] result in
                switch result {
                    case .success(let data) :
                        self?.animeList = data
                        self?.delegate?.refreshUI()
                    case .failure(_) :
                        self?.delegate?.showError()
                }
            }
        
        }
    
}
