//
//  SearchPresenterMock.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 23/01/22.
//

import XCTest
@testable import SAPFLICKER

class SearchPresenterMock:SFPresenterProtocol {
    var SFView: SearchViewProtocol?
    
    func hfinteractorDidFetchImages(_ images: [SFImageEssentialDataModelProtocol]) {
        calledMethods.append(.hfinteractorDidFetchImages)
        SFView?.didFetchImages(images)
    }
    
    func hfinteractorDidFailToFetchImages(_ error: Error) {
        calledMethods.append(.hfinteractorDidFailToFetchImages)
        SFView?.didFailToFetchImages(error)
    }
    
    func hfinteractorDidFetchHistory(_ history: [SearchHistoryResultProtocol]) {
        calledMethods.append(.hfinteractorDidFetchHistory)
        SFView?.DidFetchHistory(history)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case hfinteractorDidFetchImages
        case hfinteractorDidFailToFetchImages
        case hfinteractorDidFetchHistory
        static func == (lhs:SearchPresenterMock.CalledMethods, rhs:SearchPresenterMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.hfinteractorDidFetchImages, .hfinteractorDidFetchImages),
                 (.hfinteractorDidFailToFetchImages, .hfinteractorDidFailToFetchImages),
                (.hfinteractorDidFetchHistory, .hfinteractorDidFetchHistory):
                return true
            default:
                return false
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension SearchPresenterMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}
