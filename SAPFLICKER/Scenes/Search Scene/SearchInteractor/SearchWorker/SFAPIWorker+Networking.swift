//
//  HFAPIWorker+Networking.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation
// MARK: Netrworking methods
extension SFWorker {
    //** Define API's to be used here **
    enum API {
        case fetchImages(APIInput)
    }
}
extension SFWorker.API:SFAPICall {
   
    //** Configure each API attributes based on API enumeration **
    
    var path: String {
        SFConstants.networking.baseURL
    }
    var method: String {
        switch self {
        case .fetchImages:
            return SFConstants.networking.GET
        }
    }
    var headers: [String : String]? {
        switch self {
        case .fetchImages:
            return ["Accept":"application/json"]
        }
    }
    var microService:String {
        switch self {
        //** Getting micro service as input **
        case .fetchImages:
            return SFConstants.microServices.imageService
        }
    }
    var microServiceType:String {
        switch self {
        //** Getting micro service type as input **
        case .fetchImages:
            return SFConstants.microServices.imageServiceRest
        }
    }
    var microServiceMethod:String {
        switch self {
        //** Getting micro service method as input **
        case .fetchImages:
            return SFConstants.microServices.method
        }
    }
}
extension SFWorker.API{
    // ** Build Request body **
    func body()  -> Data? {
        switch self {
        case .fetchImages:
            return nil
        }
    }
    // ** Build final URL string **
    func buildUrlString() -> String? {
        switch self {
        case .fetchImages(let input):
            return "https://\(path)/\(microService)/\(microServiceType)/?\(SFConstants.fieldNames.method)=\(microServiceMethod)&\(SFConstants.fieldNames.apiKey)=\(SFConstants.networking.apiKey)&\(SFConstants.fieldNames.format)=\(SFConstants.networking.json)&\(SFConstants.fieldNames.nojsoncallback)=\(String(describing:input.nojsoncallback ?? ""))&\(SFConstants.fieldNames.safe_search)=\(String(describing: input.safeSearch ?? ""))&\(SFConstants.fieldNames.text)=\(String(describing: input.searchText ?? ""))"
        }
            
    }
}
