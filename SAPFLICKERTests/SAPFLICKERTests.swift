//
//  SAPFLICKERTests.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import XCTest
import UIKit
@testable import SAPFLICKER

class SAPFLICKERTests: XCTestCase {
    var SUT:SearchViewMock = SearchViewMock()
    let presenter = SearchPresenterMock()
    let networking = SearchNetworkingMock()
    let apiWorker = SearchWorkerMock()
    var interactor = SearchInteractorMock()
    

    
    func bootstrapSFView() {
        //MARK: Initialise components.
        
         apiWorker.networking = networking
        interactor.Worker = apiWorker
         
        //MARK: link VIP components.
        SUT.SFInteractor = interactor
        SUT.exp = self.expectation(description: "Completion of view didFetch/didFailed")
        presenter.SFView = SUT
        interactor.Presenter = presenter
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        bootstrapSFView()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCompleteSuccessFlow() {
        
        // Initiate Fetch Recipie with expected input model
        SUT.SFInteractor?.fetchImageses(inputModel(safeSearch: "1", nojsoncallback: "1", searchText:"Stuttgart"))
        
        //*** Wait for expectation as we are having asynchronous call in between the flow ***
        waitForExpectations(timeout: 1)
        
        //** All the fetched interfaces should only called once
        XCTAssertTrue(SUT.calledMethod(.didFetchImages))
        XCTAssertTrue(SUT.numberOfTimesCalled(.didFetchImages) == 1)
        
        XCTAssertTrue(interactor.calledMethod(.fetchImageses))
        XCTAssertTrue(interactor.numberOfTimesCalled(.fetchImageses) == 1)
        
        XCTAssertTrue(presenter.calledMethod(.hfinteractorDidFetchImages))
        XCTAssertTrue(presenter.numberOfTimesCalled(.hfinteractorDidFetchImages) == 1)
        
        XCTAssertTrue(apiWorker.calledMethod(.fetchImagesWith))
        XCTAssertTrue(apiWorker.numberOfTimesCalled(.fetchImagesWith) == 1)
        
        XCTAssertTrue(networking.calledMethod(.call))
        XCTAssertTrue(networking.numberOfTimesCalled(.call) == 1)
        
    }
    
    func testCompleteFailureFlow() {
        
        // Initiate Fetch Recipie with expected input model
        SUT.SFInteractor?.fetchImageses(nil)
        
        //*** Wait for expectation as we are having asynchronous call in between the flow ***
        waitForExpectations(timeout: 1)
        
        //** View failed interface should be called once
        XCTAssertTrue(SUT.calledMethod(.didFailToFetchImages))
        XCTAssertTrue(SUT.numberOfTimesCalled(.didFailToFetchImages) == 1)
        
        //** Interactor fetch interface should be called once
        XCTAssertTrue(interactor.calledMethod(.fetchImageses))
        XCTAssertTrue(interactor.numberOfTimesCalled(.fetchImageses) == 1)
        
        //** Presenter failed interface should be called once
        XCTAssertFalse(presenter.calledMethod(.hfinteractorDidFetchImages))
        XCTAssertFalse(presenter.numberOfTimesCalled(.hfinteractorDidFetchImages) == 1)
        
        //** Worker hit api interface should be called once
        XCTAssertTrue(apiWorker.calledMethod(.fetchImagesWith))
        XCTAssertTrue(apiWorker.numberOfTimesCalled(.fetchImagesWith) == 1)
        
        //** Call should reach networking layer as we are checking the parameter at worker leyer
        XCTAssertFalse(networking.calledMethod(.call))
        XCTAssertFalse(networking.numberOfTimesCalled(.call) == 1)
        
    }

}
