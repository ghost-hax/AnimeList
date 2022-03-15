//
//  APICallTests.swift
//  APICallTests
//
//  Created by David on 08/03/2022.
//

import XCTest
@testable import APICall


class ApiCallTest: XCTestCase {
    
    var testAnimeListViewModel: AnimeListViewModelType!
    override func setUpWithError() throws {
        let viewController = AnimeListView()
        let mockNetworkMaanger = MockNetworkManager()
        testAnimeListViewModel = AnimeListViewModel(networkManager: mockNetworkMaanger, delegate: viewController)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testGet_success() {
        
        let request = ApiRequest(baseUrl:"")
        testAnimeListViewModel.getRequest(apiRequest: request)
         
        XCTAssertEqual(testAnimeListViewModel.animeListCount , 13)
    }
    
    func testGet_failure() {
        
        let request = ApiRequest(baseUrl:"incorrect_url")
        testAnimeListViewModel.getRequest(apiRequest: request)
         
        XCTAssertEqual(testAnimeListViewModel.animeListCount , 0)
    }
    
    func testPreIOS13Get_success() {
        
        let request = ApiRequest(baseUrl:"")
        testAnimeListViewModel.preIOS13GetRequest(apiRequest: request)
         
        XCTAssertEqual(testAnimeListViewModel.animeListCount , 13)
    }
    
    func testPreIOS13Get_failure() {
        
        let request = ApiRequest(baseUrl:"incorrect_url")
        testAnimeListViewModel.preIOS13GetRequest(apiRequest: request)
         
        XCTAssertEqual(testAnimeListViewModel.animeListCount , 0)
    }

    func testGet_successForSpecificValue() {
        
        var data = testAnimeListViewModel.getDataValues(index: 2)
        
        XCTAssertNil(nil)
        
         data = testAnimeListViewModel.getDataValues(index: -1)
        
        XCTAssertNil(nil)
        
        let request = ApiRequest(baseUrl:"")
        testAnimeListViewModel.preIOS13GetRequest(apiRequest: request)
         
        data = testAnimeListViewModel.getDataValues(index: 0)
       
        XCTAssertNotNil(data)
        
        XCTAssertEqual(data!.animeName, "bleach")
    }

}
