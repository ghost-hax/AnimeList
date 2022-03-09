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

struct ModelValue {
    var animeId: String
    var animeName: String
    var animeImg: String
}

protocol ViewModelType: AnyObject {
    
    var stateBinding: Published<ViewState>.Publisher { get }
    var data:Model? { get }
    var dataCount:Int { get }
    
    func getRequest(apiRequest: ApiRequestType)
    func fetch(request: ApiRequest)
    func getDataValues(index:Int)-> ModelValue?
}

final class ViewModel: ViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var data:Model?

    var dataCount:Int {
        guard let dataCount = data?.data.count else { return 0 }
        return dataCount
    }
    
    private var networkManager: Networkable
    private weak var delegate: ViewControllerType?
    
    init(networkManager:Networkable = Networking(), delegate:ViewControllerType) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func getRequest(apiRequest: ApiRequestType) {
        
        state = ViewState.loading
        let publisher =   networkManager.doApiCall(apiRequest: apiRequest, type:Model.self)//self.repository.getRepository(apiRequest: apiRequest)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] received in
            self?.data = received
            
            self?.state = ViewState.finishedLoading
        }

        self.cancellables.insert(cancalable)
    }
    
    func getDataValues(index: Int)-> ModelValue? {
        guard index < dataCount && index >= 0 else {
            return nil
        }
        
        guard let dataModel = data?.data[index]
        else { return ModelValue(
                                    animeId: "",
                                    animeName:"",
                                    animeImg: "")}
        
        return ModelValue(
                          animeId: "\(dataModel.animeId)" ,
                          animeName: dataModel.animeName ,
                          animeImg: dataModel.animeImg )
        
    }
    
    // MARK: - for Older iOS versions (Pre iOS 13)
        func fetch(request: ApiRequest) {
            
            networkManager.get(request, type: Model.self) {[weak self] result in
                
                switch result {
                    case .success(let data) :
                        self?.data = data
                        self?.delegate?.refreshUI()
                    case .failure(_) :
                        self?.delegate?.showError()
                }
            }
        
        }
    
}
