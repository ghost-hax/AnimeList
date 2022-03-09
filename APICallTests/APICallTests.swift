//
//  APICallTests.swift
//  APICallTests
//
//  Created by David on 08/03/2022.
//

import XCTest
@testable import APICall


class StaffAndRoomsTests: XCTestCase {
    
    var viewModel: ViewModelType!
    override func setUpWithError() throws {
        let viewController = ViewController()
        let mockNetworkMaanger = MockNetworkManager()
        viewModel = ViewModel(networkManager: mockNetworkMaanger, delegate: viewController)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchStaff_success() {
        
        let request = ApiRequest(baseUrl:"", path: "")
        viewModel.fetch(request: request)
         
        XCTAssertEqual(viewModel.dataCount , 13)
    }
    
    func testFetchStaff_failure() {
        
        let request = ApiRequest(baseUrl:"", path: "failure_response")
        viewModel.fetch(request: request)
         
        XCTAssertEqual(viewModel.dataCount , 0)
    }

    func testGetStaff() {
        
        var data = viewModel.getDataValues(index: 2)
        
        XCTAssertNil(nil)
        
         data = viewModel.getDataValues(index: -1)
        
        XCTAssertNil(nil)
        
        let request = ApiRequest(baseUrl:"", path: "")
        viewModel.fetch(request: request)
         
        data = viewModel.getDataValues(index: 0)
       
        XCTAssertNotNil(data)
        
        XCTAssertEqual(data!.animeName, "bleach")
    }

}
