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

struct AnimeValue {
    var animeId: String
    var animeName: String
    var animeImg: String
}

protocol AnimeListViewModelType: AnyObject {
    
    var stateBinding: Published<ViewState>.Publisher { get }
    var animeListCount:Int { get }
    
    func getRequest(apiRequest: ApiRequestType)
    func preIOS13GetRequest(apiRequest: ApiRequest)
    func getDataValues(index:Int)-> AnimeValue?
    func refreshUI()
    func showError()
}

final class AnimeListViewModel: AnimeListViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $loadingState }
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var loadingState: ViewState = .none
    
    var animeListCount:Int {
        guard let dataCount = coordinator?.animeListCount else { return 0 }
        return dataCount
    }
    
    private weak var delegate: AnimeListViewType?
    private var coordinator:CoordinatorType?
    
    init(networkManager:NetworkManagerType = NetworkManager(), delegate:AnimeListViewType) {
        self.delegate = delegate
        self.coordinator = Coordinator(networkManager:networkManager, delegate: self)
    }
    
    func getDataValues(index: Int)-> AnimeValue? {
        guard index < animeListCount && index >= 0 else {
            return nil
        }
        
        guard let dataModel = coordinator?.animeList?.data[index]
        else { return AnimeValue(   animeId: "",
                                    animeName:"",
                                    animeImg: "")}
        
        return AnimeValue(animeId: "\(dataModel.animeId)" ,
                          animeName: dataModel.animeName ,
                          animeImg: dataModel.animeImg )
        
    }
    
    func getRequest(apiRequest: ApiRequestType) {
        
        loadingState = ViewState.loading
        
        guard let coordinator = coordinator else {
            return
        }

        let cancellable =  coordinator.stateBinding.sink { completion in
              
          } receiveValue: { [weak self] launchState in
                self?.loadingState = launchState
          }
          self.cancellables.insert(cancellable)

        coordinator.getRequest(apiRequest: apiRequest, type: AnimeList.self)
        
        
    }
    
    func refreshUI(){
        delegate?.refreshUI()
    }
    
    func showError(){
        delegate?.showError()
    }
    
    
    // MARK: - for Older iOS versions (Pre iOS 13)
        func preIOS13GetRequest(apiRequest: ApiRequest) {
            
            coordinator?.preIOS13GetRequest(apiRequest: apiRequest, type: AnimeList.self, completionHandler: { result in
                
            })
        }
    
}
