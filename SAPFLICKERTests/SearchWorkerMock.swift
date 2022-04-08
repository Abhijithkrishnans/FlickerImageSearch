//
//  SearchWorkerMock.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 23/01/22.
//

import XCTest
@testable import SAPFLICKER

class SearchWorkerMock:SFWorkerProtocol {
    var networking: SFNetworkingProtocol?
    
    func fetchImagesWith(_ inputModel: APIInput?, completion: @escaping imageListCompletion) {
        calledMethods.append(.fetchImagesWith)
        guard let inputParam = inputModel else {
            completion(SFImageResult.Failure(SFError.requestBuildFailure.undefinedInput))
            return
        }
      
        networking?.call(endPoint: API.fetchImages(inputParam), completion: { (data, response, error) in
            DispatchQueue.main.async {
            if let err = error {
                completion(SFImageResult.Failure(err))
                return
            }
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(SFImageResult.Failure(SFError.apiFailure.noResponse))
                return
            }
            guard let successData = data, HTTPCodes.success ~= urlResponse.statusCode else {
                completion(SFImageResult.Failure(SFError.apiFailure.noData))
                return
            }
            guard let loadedDataModel = SFUtilities().getDecodedData(type: SFMasterDataModel.self, data: successData) else {
                completion(SFImageResult.Failure(SFError.jsonEncodingFailure.decodeFailed))
                return
            }
            guard let masterImageList = loadedDataModel.photos?.photo else {
                completion(SFImageResult.Failure(SFError.jsonEncodingFailure.decodeFailed))
                return
            }
            // *** Successfully decoded JSON response to data model for further manipulation
                completion(SFImageResult.Success(masterImageList))
            }
        }) 
        
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case fetchImagesWith
        static func == (lhs:SearchWorkerMock.CalledMethods, rhs:SearchWorkerMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.fetchImagesWith, .fetchImagesWith):
                return true
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension SearchWorkerMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

extension SearchWorkerMock {
    enum API {
        case fetchImages(APIInput)
    }
}
extension SearchWorkerMock.API:SFAPICall {
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
extension SearchWorkerMock.API{
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
