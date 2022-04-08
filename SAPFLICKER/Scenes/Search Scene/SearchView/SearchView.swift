//
//  SearchView.swift
//  iOS Test
//
//  Created by Abhijithkrishnan on 26/03/21.
//

import UIKit
import SDWebImage
// MARK: View Protocol
//*** Responsibile for view requirements ***
//*** Image Fetch results request and error are injected through this interface ***
protocol SearchViewProtocol:AnyObject {
    //** Interactor connection requirement
    var SFInteractor:SFInteractorProtocol? {get set}
    
    //** Image Fetching interfaces
    func didFetchImages(_ images:[SFImageEssentialDataModelProtocol])
    func didFailToFetchImages(_ error:Error)
    
    func DidFetchHistory(_ history:[SearchHistoryResultProtocol])
}
class SearchView: UIViewController,SearchViewProtocol {
   
    //MARK: Properties
    var SFInteractor: SFInteractorProtocol?
    var searchController:UISearchController = UISearchController(searchResultsController:nil)
    
    //MARK: Outlets
    @IBOutlet weak var tvSearchHistory: UITableView!
    @IBOutlet weak var cvImageCollection: UICollectionView!
    
    //MARK: Image custom properties
    //*** Observing all the changes to update the UI **
    var imageList = [SFImageEssentialDataModelProtocol]() {
        didSet {
            reloadImageList()
        }
    }
    
    //*** Observing all the changes to update the UI **
    var historyList = [SearchHistoryResultProtocol]() {
        didSet {
            reloadHistoryList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCollectionView()
        initializeSearchController()
        commonInitializer()
    }
}

//MARK: Common initializers
extension SearchView {
    private func commonInitializer() {
        let reset = UIBarButtonItem(title: SFConstants.screenTitle.resetButtonTitle, style: .plain, target: self, action: #selector(didClickReset))
        navigationItem.rightBarButtonItems = [reset]
        if let searchTextField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(self.didClickReset), for: .touchUpInside)
        }
    }
    private func initializeCollectionView() {
        let FlowLayout = UICollectionViewFlowLayout()
        FlowLayout.minimumInteritemSpacing = 1
        FlowLayout.minimumLineSpacing = 1
        cvImageCollection.collectionViewLayout = FlowLayout
        cvImageCollection.contentInsetAdjustmentBehavior = .always
    }
   
    private func initializeSearchController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = SFConstants.screenTitle.HomeTitle
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = SFConstants.screenTitle.searchBarPlaceHolder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: Common helpers
extension SearchView {
    //** Recipie List Reload Logic
    private func reloadImageList() {
        DispatchQueue.main.async {
            self.cvImageCollection.reloadData()
        }
    }
    private func reloadHistoryList() {
        DispatchQueue.main.async {
            self.tvSearchHistory.reloadData()
        }
    }
    private func clearSerch(partially:Bool) {
        tvSearchHistory.isHidden = true
        searchController.isActive = partially
    }
    private func bringHistorlyList() {
        tvSearchHistory.isHidden = false
    }
    private func insertSearchEtry(searchText:String){
        
        var entryID = Int32((self.historyList.count))
        var index = 0
        var intelligence:Int64 = 0
        if historyList.contains(where: {$0.text == searchText}) {
            index =  historyList.firstIndex(where: {$0.text == searchText}) ?? 0
            intelligence = Int64(historyList[index].intelligence + 1)

        }else {
            entryID += 1
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.SFInteractor?.insertSearchHistory(historyDataModel(id: entryID, text: searchText, intelligence: intelligence))
            
        }
    }
    private func initiateSearch(searchText text:String){
        self.view.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.view.sd_imageIndicator?.startAnimatingIndicator()
        clearSerch(partially: true)
        SFInteractor?.fetchImageses(inputModel(safeSearch: "1", nojsoncallback: "1", searchText:text))
        insertSearchEtry(searchText: text)
    }
    @objc func didClickReset() {
        imageList.removeAll()
        cvImageCollection.reloadData()
        clearSerch(partially: false)
    }
}

//MARK: Image Fetch helper methods
extension SearchView {
    
    //** Initial fetch and updated results injecte through this interface
    func didFetchImages(_ images: [SFImageEssentialDataModelProtocol]) {
        self.view.sd_imageIndicator?.stopAnimatingIndicator()
        clearSerch(partially: true)
        self.view.sd_imageIndicator?.stopAnimatingIndicator()
        imageList = images
    }
    
    //** All the exceptions are exposed through this interface
    func didFailToFetchImages(_ error: Error) {
        self.view.sd_imageIndicator?.stopAnimatingIndicator()
        let castedError = (error as NSError)
        UIAlertController.showAlert(title: castedError.localizedDescription, message: SFConstants.fieldNames.empty, cancelButtonTitle: SFConstants.fieldNames.Ok, otherButtons: [], preferredStyle: .alert, vwController: self) { (action, index) in
            switch castedError.code {
            case SFError.apiFailure.connectivityError.rawValue:
                    // ** Hitting again after network connectivity restored
                break
            default:
                break
            }
        }
    }
    //** Search history Fetch injected through this interface
    func DidFetchHistory(_ history:[SearchHistoryResultProtocol]){
        historyList = history.sorted(by: {$0.intelligence > $1.intelligence})
    }
}

// MARK: Collection delegates and datasource methods
extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageList.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            cell.configureCellWith(imageList[indexPath.item])
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: SFConstants.commonSize.cellWidth, height: SFConstants.commonSize.cellHeight)
        }
}
// MARK: SearchBar delegates methods
extension SearchView: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        bringHistorlyList()
        SFInteractor?.fetchSearchHistory()
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearSerch(partially: true)
        initiateSearch(searchText: searchBar.text?.trimmingCharacters(in: .whitespaces) ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tvSearchHistory.isHidden = true
    }

}
// MARK: TableView delegates and datasource methods
extension SearchView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
     }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell", for: indexPath) as! SearchHistoryCell
        cell.userActivity?.title = historyList[indexPath.row].text
        cell.textLabel?.text = historyList[indexPath.row].text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        initiateSearch(searchText:historyList[indexPath.row].text)
        clearSerch(partially: false)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SFInteractor?.deleteSearchHistory(historyList[indexPath.row])
            historyList.remove(at: indexPath.row)
            tvSearchHistory.reloadData()
        }
    }
}
