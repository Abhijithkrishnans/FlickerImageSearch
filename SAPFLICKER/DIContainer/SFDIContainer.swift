//
//  SFDIContainer.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import Foundation
struct DIContainer {

    static func bootstrapHFView(viewC:SearchView) -> SearchView {
        //MARK: Initialise components.
         let view = viewC
         let presenter = SFPresenter()
         let apiWorker = SFWorker()
        let dbWorker = DataManager.shared
        let _ = CFCoreDataHelper.shared.persistentContainer.viewContext
         apiWorker.networking = SFNetworking()
         let interactor = SFInteractor()
        interactor.Worker = apiWorker
        interactor.DBWorker = dbWorker
         
        //MARK: link VIP components.
        view.SFInteractor = interactor
        presenter.SFView = view
        interactor.Presenter = presenter
        return view
    }
}
