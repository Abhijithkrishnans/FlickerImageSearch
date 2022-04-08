//
//  SearchViewMock.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 23/01/22.
//

import XCTest
@testable import SAPFLICKER

class SearchViewMock:SearchViewProtocol {
    var SFInteractor: SFInteractorProtocol?
    var exp:XCTestExpectation?
    func didFetchImages(_ images: [SFImageEssentialDataModelProtocol]) {
        calledMethods.append(.didFetchImages)
        exp?.fulfill()
    }
    
    func didFailToFetchImages(_ error: Error) {
        calledMethods.append(.didFailToFetchImages)
        exp?.fulfill()
    }
    
    func DidFetchHistory(_ history: [SearchHistoryResultProtocol]) {
        calledMethods.append(.DidFetchHistory)
        exp?.fulfill()
    }
    

    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case didFetchImages
        case didFailToFetchImages
        case DidFetchHistory
        static func == (lhs:SearchViewMock.CalledMethods, rhs:SearchViewMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.didFetchImages, .didFetchImages),
                 (.didFailToFetchImages, .didFailToFetchImages),
                (.DidFetchHistory, .DidFetchHistory):
                return true
            default:
                return false
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension SearchViewMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}
