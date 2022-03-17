//
//  Coordinator.swift
//  APICall
//
//  Created by David on 15/03/2022.
//

import Foundation
import UIKit

protocol CoordinatorType{
    
    var navigationController: UINavigationController { get set }
    func start()
   
}

class Coordinator: CoordinatorType{
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AnimeListView.instantiate()
        vc.coordinator = self
        vc.animeListViewModel = AnimeListViewModel(delegate:vc)
        navigationController.pushViewController(vc, animated: false)
    }
    
}
