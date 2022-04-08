//
//  HFInteractor.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation

//MARK:- Interactor Protocol
protocol SFInteractorProtocol {
    //** Presenter connection to expose the fetched results to pipeline **
    var Presenter:SFPresenterProtocol? {get set}
    //** API Worker connection to act as helper **
    var Worker:SFWorkerProtocol? {get set}
    //** DB Worker connection to act as helper **
    var DBWorker: DataRepositoryProtocol? {get set}
    //** Data fetch initiation interface **
    func fetchImageses(_ inputModel:APIInput?)
    
    //** Insert/Fetch Search History **
    func insertSearchHistory(_ inputModel:SearchHistoryResultProtocol)
    func fetchSearchHistory()
    func deleteSearchHistory(_ inputModel:SearchHistoryResultProtocol)
}
class SFInteractor:SFInteractorProtocol{
    var Worker: SFWorkerProtocol?
    var Presenter: SFPresenterProtocol?
    var DBWorker: DataRepositoryProtocol?
    
}
//MARK:- Image Fetch/Insert/Delete Methods
extension SFInteractor {
    func fetchImageses(_ inputModel:APIInput?) {
        Worker?.fetchImagesWith(inputModel, completion: { [weak self] recipeResult in
            switch recipeResult {
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
        DBWorker?.insertHistoryList(list: inputModel)
    }
    func fetchSearchHistory() {
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
        DBWorker?.deleteItem(inputModel)
    }
}

