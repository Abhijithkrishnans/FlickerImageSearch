//
//  HFAPIRepoWorker.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation
typealias imageListCompletion = (_ imageResult: SFImageResult) -> Void
//MARK:- Worker protocol
//***Access to worker outside interactor is forbidden***
protocol SFWorkerProtocol {
    //** Network manager connection requirement
    var networking:SFNetworkingProtocol? {get set}
    
    //** Interface used for performing API call for fetching recpies
    func fetchImagesWith(_ inputModel:APIInput?,completion: @escaping imageListCompletion)
    
}
class SFWorker: NSObject, SFWorkerProtocol {
    var networking:SFNetworkingProtocol?
}

//MARK:- Recipie List Methods
extension SFWorker {
    func fetchImagesWith(_ inputModel:APIInput?,completion: @escaping imageListCompletion) {
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
    
}
