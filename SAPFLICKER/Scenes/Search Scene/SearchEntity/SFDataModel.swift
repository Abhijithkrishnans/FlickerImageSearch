//
//  HFDataModel.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation
//MARK: Data Model Protocols
//Define necessary data model attributes
protocol SFImageEssentialDataModelProtocol {
    var id:String? {get set}
    var secret:String? {get set}
    var server:String? {get set}
    var farm:Int? {get set}
    
}

protocol SFImageOptionalDataModelProtocol {
    
    var owner:String? {get set}
    var secret:String? {get set}
    var server:String? {get set}
    var farm:Int? {get set}
    var title:String? {get set}
    var ispublic:Int? {get set}
    var isfriend:Int? {get set}
    var isfamily:Int? {get set}
}

// MARK: Master Data model
struct SFMasterDataModel:Codable {
    var photos:SFImageDataModel?
    var stat:String?
}
// MARK: Image Data model
struct SFImageDataModel:Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: [SFCombinedDataModel]?
}
// MARK: Combined Data model
struct SFCombinedDataModel:Codable,SFImageEssentialDataModelProtocol,SFImageOptionalDataModelProtocol {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}

//MARK: Search History DataModel
//Define Necessary input params here
protocol SearchHistoryResultProtocol {
    var id:Int32 {get set}
    var text:String {get set}
    var intelligence: Int64 {get set}
}
//MARK: SearchHistory Data Model
struct historyDataModel:SearchHistoryResultProtocol {
    var id: Int32
    var text: String
    var intelligence: Int64
}
// MARK: Core data to model mapping helpers
extension SearchHistory {
    func convertToHistoryResultModel() ->SearchHistoryResultProtocol  {
        return historyDataModel(id: id, text: searchtext ?? "", intelligence: intelligence)
    }
}

//MARK: Input API Protocol
//Define Necessary input params here
protocol APIInput {
    var searchText:String? {get set}
    var safeSearch:String? {get set}
    var nojsoncallback:String? {get set}
}
//MARK: Input API Model
struct inputModel:APIInput {
    var safeSearch: String?
    var nojsoncallback: String?
    var searchText: String?
}
