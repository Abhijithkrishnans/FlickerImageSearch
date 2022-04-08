//
//  SearchInteractorMock.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 23/01/22.
//

import XCTest
@testable import SAPFLICKER
class SearchInteractorMock:SFInteractorProtocol {
    var Presenter: SFPresenterProtocol?
    var DBWorker: DataRepositoryProtocol?
    var Worker: SFWorkerProtocol?
    
    func fetchImageses(_ inputModel: APIInput?) {
        calledMethods.append(.fetchImageses)
        Worker?.fetchImagesWith(inputModel, completion: { [weak self] imageResult in
            switch imageResult {
            case .Success(let results):
                //**Injecting recipie list to view**
                self?.Presenter?.hfinteractorDidFetchImages(results)
                break
            case .Failure(let error):
                //**Injecting erro to view**
                self?.Presenter?.hfinteractorDidFailToFetchImages(error)
                break
            }
        })
    }
    
    func insertSearchHistory(_ inputModel:SearchHistoryResultProtocol) {
        calledMethods.append(.insertSearchHistory)
        DBWorker?.insertHistoryList(list: inputModel)
    }
    func fetchSearchHistory() {
        calledMethods.append(.fetchSearchHistory)
        DBWorker?.fetchHistoryList([], completion: { imageResult in
            switch imageResult {
            case .Success(let results):
                //**Injecting recipie list to view**
                self.Presenter?.hfinteractorDidFetchHistory(results)
                break
            case .Failure:
                break
            }
        })
    }
    func deleteSearchHistory(_ inputModel:SearchHistoryResultProtocol) {
        calledMethods.append(.deleteSearchHistory)
        DBWorker?.deleteItem(inputModel)
    }
    
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case fetchImageses
        case insertSearchHistory
        case fetchSearchHistory
        case deleteSearchHistory
        static func == (lhs:SearchInteractorMock.CalledMethods, rhs:SearchInteractorMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.fetchImageses, .fetchImageses),
                 (.insertSearchHistory, .insertSearchHistory),
                (.fetchSearchHistory, .fetchSearchHistory),
                (.deleteSearchHistory, .deleteSearchHistory):
                return true
            default:
                return false
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension SearchInteractorMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}
