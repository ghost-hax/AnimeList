//
//  ViewController.swift
//  APICall
//
//  Created by David on 08/03/2022.
//

import UIKit
import Combine

protocol AnimeListViewType: AnyObject{
    func refreshUI()
    func showError()
    
}

class AnimeListView: UIViewController {
    
    private var animeListViewModel:AnimeListViewModelType!
    private var bindings = Set<AnyCancellable>()
    
    var activityIndicator = UIActivityIndicatorView()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.isHidden = true
        return tableView
    }()
    
    var cellID:String = "Cell"
    let request = ApiRequest(baseUrl: EndPoint.baseUrl)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        setupUI()
        
        animeListViewModel = AnimeListViewModel(delegate:self)
        
        if #available(iOS 13.0, *) {
            animeListViewModel.getRequest(apiRequest: request)
            setupBindings()
        }else {
            animeListViewModel.preIOS13GetRequest(apiRequest: request)
        }
    }
    
    private func setupUI() {
        self.view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
            activityIndicator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0.0).isActive = true
            activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
            activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10.0).isActive = true
        self.view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(AnimeListTableViewCell.self, forCellReuseIdentifier:cellID)
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0.0).isActive = true
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10.0).isActive = true
    }
    
    private func setupBindings() {
        bindViewModelState()
    }
    
    private func bindViewModelState() {
      let cancellable =  animeListViewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            tableView.isHidden = true
        case .loading:
            tableView.isHidden = true
            activityIndicator.startAnimating()
        case .finishedLoading:
            refreshUI()
        case .error(let error):
            showError()
            showAlert(message:error)
        }
    }
    
    func showAlert(message:String) {
        let alertViewController = UIAlertController(title:"Error Connecting", message:message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.cancel, handler: { (alert) in
            alertViewController.dismiss(animated:true, completion:nil)
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated:true, completion:nil)
    }
}

extension AnimeListView:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeListViewModel.animeListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? AnimeListTableViewCell else{return UITableViewCell()}
       
        if let ModelValue = animeListViewModel.getDataValues(index: indexPath.row) { cell.setData(data: ModelValue)}
        return cell
    }
    
}

extension AnimeListView: AnimeListViewType {
    func refreshUI() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.activityIndicator.isHidden = true
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.activityIndicator.isHidden = true
        }
    }
}
