//
//  SFDBWorker.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//


import Foundation
import Foundation
import CoreData

typealias historyCompletion = (_ imageResult: SFImageResult.HistoryResult) -> Void
protocol DataRepositoryProtocol {
    func fetchHistoryList(_ filterParams:[String], completion: @escaping historyCompletion)
    func insertHistoryList(list:SearchHistoryResultProtocol)
    func updateItem(_ item:SearchHistoryResultProtocol)
    func deleteItem(_ item:SearchHistoryResultProtocol)
    func flushDB()
}

class DataManager: DataRepositoryProtocol {
    
    static let shared:DataRepositoryProtocol = DataManager()
    var dbHelper:CFCoreDataHelper = CFCoreDataHelper.shared
    private init() {}
}

//MARK:- Check for DB data methods
extension DataManager {
    
    private func checkDBLoaded()-> Bool {
        let result:Result<[SearchHistory],Error> = dbHelper.fetch(SearchHistory.self, predicate: nil)
        switch result {
        case .success(let items):
            return !items.isEmpty
        case .failure:
            return false
        }
    }
    private func checkDuplicateEntry(list:SearchHistoryResultProtocol)-> Bool {
        let result:Result<[SearchHistory],Error> = dbHelper.fetch(SearchHistory.self, predicate: getDatePredicateWithParam([list.text]))
        switch result {
        case .success(let items):
            return !items.isEmpty
        case .failure:
            return false
        }
    }
}

//MARK:- DB OPERATIONS INTERFCES
extension DataManager {
    func insertHistoryList(list:SearchHistoryResultProtocol) {
        if !checkDuplicateEntry(list: list) {
            let entity = SearchHistory.entity()
            let newHistoryInstance = SearchHistory(entity: entity, insertInto: dbHelper.context)
            newHistoryInstance.id = list.id
            newHistoryInstance.searchtext = list.text
            newHistoryInstance.intelligence = list.intelligence
            dbHelper.create(newHistoryInstance)
        }else {
            updateItem(list)
        }
    }
    func fetchHistoryList(_ filterParams:[String], completion: @escaping historyCompletion){
        let result:Result<[SearchHistory],Error> = dbHelper.fetch(SearchHistory.self, predicate:nil)
        parseFetchResultWith(result) { imageResult in
            completion(imageResult)
        }
    }
    func updateItem(_ item:SearchHistoryResultProtocol) {
        let result:Result<[SearchHistory],Error> = dbHelper.fetch(SearchHistory.self, predicate: getDatePredicateWithParam([item.text]))
        switch result {
        case .success(let result):
            
            let newHistoryInstance = result[0]
            newHistoryInstance.searchtext = item.text
            newHistoryInstance.id = item.id
            newHistoryInstance.intelligence = item.intelligence
            dbHelper.update(newHistoryInstance)
            break
        case .failure(_):
            // DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE UPDATING****\(result)")
            break
        }
        
       
    }
    func deleteItem(_ item: SearchHistoryResultProtocol) {
        let result:Result<[SearchHistory],Error> = dbHelper.fetch(SearchHistory.self, predicate: getDatePredicateWithParam([item.text]))
        switch result {
        case .success(let result):
            let newHistoryInstance = result[0]
            dbHelper.delete(newHistoryInstance)
            break
        case .failure(_):
            // DB fetch Failure... Since it is BG operation no need birng as a prompt to user
            print("****DB FETCH FAILED WHILE DELETING****\(result)")
            break
        }
    }
    
    func flushDB(){
        dbHelper.flushDB(SearchHistory.self)
    }
}

//MARK:- Predicates
extension DataManager {
    private func getDatePredicateWithParam(_ filterParam:[String]) -> NSCompoundPredicate {
        var compPredicateArr = [NSPredicate]()
        
        filterParam.forEach { param in
            compPredicateArr.append(NSPredicate(format: "searchtext == '\(param)'"))
        }
        return NSCompoundPredicate(type: .or, subpredicates: compPredicateArr)
    }
}

//MARK:- Parser
extension DataManager {
func parseFetchResultWith(_ result:Result<[SearchHistory],Error>, completion: @escaping historyCompletion){
    switch result {
    case .success(let result):
        completion(SFImageResult.HistoryResult.Success(result.map{$0.convertToHistoryResultModel()}))
        break
    case .failure(let error):
        completion(SFImageResult.HistoryResult.Failure(error))
            break
    }
}
}
