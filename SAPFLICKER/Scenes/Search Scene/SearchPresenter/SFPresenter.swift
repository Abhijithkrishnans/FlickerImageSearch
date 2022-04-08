//
//  SFPresenter.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import Foundation
//MARK:- Presenter protocol
protocol SFPresenterProtocol {
    //*** Presenter to View Connecter requirement ***
    //*** Should only keep weak reference while confirming, with view to avoid strong retain cycles ***
    var SFView: SearchViewProtocol? { get set }
    
    //*** Default fetch/Fail handler interfaces ***
    func hfinteractorDidFetchImages(_ images:[SFImageEssentialDataModelProtocol])
    func hfinteractorDidFailToFetchImages(_ error:Error)
    
    func hfinteractorDidFetchHistory(_ history:[SearchHistoryResultProtocol])
}
class SFPresenter: SFPresenterProtocol {
   
    weak var SFView: SearchViewProtocol?
}

//MARK: Image Fetch precentation Methods
extension SFPresenter {
    func hfinteractorDidFetchImages(_ images: [SFImageEssentialDataModelProtocol]) {
        SFView?.didFetchImages(images)
    }
    
    func hfinteractorDidFailToFetchImages(_ error: Error) {
        SFView?.didFailToFetchImages(error)
    }
    func hfinteractorDidFetchHistory(_ history:[SearchHistoryResultProtocol]) {
        SFView?.DidFetchHistory(history)
    }
}

