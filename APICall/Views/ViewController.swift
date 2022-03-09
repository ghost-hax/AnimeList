//
//  ViewController.swift
//  APICall
//
//  Created by David on 08/03/2022.
//

import UIKit
import Combine

protocol ViewControllerType: AnyObject{
    func refreshUI()
    func showError()
    
}

class ViewController: UIViewController {
    
    private var viewModel:ViewModelType!
    private var bindings = Set<AnyCancellable>()
    
    var activityIndicator = UIActivityIndicatorView()
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    var cellID:String = "Cell"
    let request = ApiRequest(baseUrl: EndPoint.baseUrl, path: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.activityIndicator.startAnimating()
        
        viewModel = ViewModel(delegate:self)
        
        if #available(iOS 13.0, *) {
            viewModel.getRequest(apiRequest: request)
            setupBindings()
        }else {
            viewModel.fetch(request: request)
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
            tableView.register(TableViewCell.self, forCellReuseIdentifier:cellID)
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -0.0).isActive = true
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10.0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10.0).isActive = true
    }
    
    private func setupBindings() {
//        bindSearchTextFieldToViewModel()
        bindViewModelState()
    }
    
    private func bindViewModelState() {
      let cancellable =  viewModel.stateBinding.sink { completion in
            
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
        let alertViewController = UIAlertController(title:"Message", message:message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title:"Ok", style: UIAlertAction.Style.cancel, handler: { (alert) in
            alertViewController.dismiss(animated:true, completion:nil)
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated:true, completion:nil)
    }
}

extension ViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? TableViewCell else{return UITableViewCell()}
       
        if let data = viewModel.getDataValues(index: indexPath.row) { cell.setData(data: data)}
        return cell
    }
    
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.getDataValues(index: indexPath.row) {
            performSegue(withIdentifier: "Page2", sender: data)
        }
    }
}

extension ViewController: ViewControllerType {
    func refreshUI() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
//            self.activityIndicator.isHidden = true
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
