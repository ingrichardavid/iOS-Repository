//
//  VCMixMovieSerie.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import UIKit
import KRLCollectionViewGridLayout
import AlamofireImage

class VCMixMovieSerie: UIViewController {

    //MARK: - Variables and Constants.
    
    fileprivate var parameterPage: Int = 1
    fileprivate var entityMovieSerieArray: [EntityMixMovieSerie] = [EntityMixMovieSerie]()
    fileprivate var filteredMovieSerieArray: [EntityMixMovieSerie] = [EntityMixMovieSerie]()
    fileprivate var uiSearchController: UISearchController = UISearchController().omDBSearchStyle
    fileprivate var numberOfItemsPerSection: Int = 0
    fileprivate var layout: KRLCollectionViewGridLayout {
        return self.uiCollectionView.collectionViewLayout as! KRLCollectionViewGridLayout
    }
    
    fileprivate let parameterMovie: String = "Movie"
    fileprivate let parameterSeries: String = "Series"
    fileprivate let placeholderSearchBar: String = "Search"
    fileprivate let cellIdentifier: String = "cell"
    fileprivate let bottomRefreshController: UIRefreshControl = UIRefreshControl()
    
    //MARK: - @IBOutlet.
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak var uiContainerViewSearchBar: UIView!
    @IBOutlet weak var uiContainerViewCollectionView: UIView!
    @IBOutlet weak var uiSegmentControlMix: UISegmentedControl!
    @IBOutlet weak var nsLCSegmentControlMix: NSLayoutConstraint!
    @IBOutlet weak var uiLabelMessage: UILabel!
    
    //MARK: - @IBAction.
    
    @IBAction func uiSCValueChanged(_ sender: UISegmentedControl) {
        guard (self.uiSearchController.searchBar.text?.characters.count)! > 0 else {
            return
        }
        self.parameterPage.omDBSearchRestartParameter()
        self.entityMovieSerieArray.removeAll()
        self.requestMovieSerie(text: self.uiSearchController.searchBar.text,
                               type: self.uiSegmentControlMix.selectedSegmentIndex,
                               scrolling: false)
    }
    
    //MARK: - UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.uiSearchController.searchBar.delegate = self
        self.uiSearchController.searchResultsUpdater = self
        self.uiContainerViewSearchBar.addSubview(self.uiSearchController.searchBar)
        
        self.layout.sectionInset = UIEdgeInsets(top: 10,
                                                left: 10,
                                                bottom: 0,
                                                right: 10)
        
        self.bottomRefreshController.tintColor = UIColor.orange
        self.bottomRefreshController.triggerVerticalOffset = 50
        self.bottomRefreshController.addTarget(self,
                                               action: #selector(VCMixMovieSerie.refreshBottom),
                                               for: UIControlEvents.valueChanged)
        
        self.uiCollectionView.bottomRefreshControl = self.bottomRefreshController
        
        self.uiLabelMessage.text = EnumLocalizableString.MESSAGE_LABEL.localized
        
        self.showOrHiddenComponents(showOrHidden: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard UIDevice.current.orientation.isLandscape else {
            self.layout.numberOfItemsPerLine = 2
            return
        }
        
        self.layout.numberOfItemsPerLine = 3
    }
    
    // MARK: - Navigation.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        
        guard segue.identifier != EnumSegues.segueMixDetail else {
            let vcMixDetail: VCMixDetail = segue.destination as! VCMixDetail
            vcMixDetail.entitiesMixMovieSerie = sender as! EntityMixMovieSerie

            return
        }
    }
    
}

//MARK: - Functions: Self.

extension VCMixMovieSerie {

    func refreshBottom() {
        self.requestMovieSerie(text: self.uiSearchController.searchBar.text,
                               type: self.uiSegmentControlMix.selectedSegmentIndex,
                               scrolling: true)
    }
    
    fileprivate func modifyConstraint(nsLayoutConstraint: NSLayoutConstraint, constant: CGFloat, duration: CGFloat) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        nsLayoutConstraint.constant = constant
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func showOrHiddenComponents(showOrHidden: Bool) {
        self.uiCollectionView.isHidden = showOrHidden
        self.uiLabelMessage.isHidden = !showOrHidden
    }
    
    //MARK: - Services
    
    fileprivate func requestMovieSerie(text: String!, type: Int!, scrolling: Bool) {
        if !scrolling {
            Functions.showActivityIndicatorView(uiParamView: self.uiContainerViewCollectionView)
        }
        
        if self.entityMovieSerieArray.count > 0 {
            guard self.entityMovieSerieArray[0].totalResults! > self.entityMovieSerieArray.count   else {
                return self.uiCollectionView.bottomRefreshControl!.endRefreshing()
            }
        }
        
        self.uiSearchController.searchBar.endEditing(true)
        
        APIServices().get_mix_movie_serie(text: text,
                                          type: type == 0 ? self.parameterMovie.lowercased() : self.parameterSeries.lowercased(),
                                          page: self.parameterPage,
                                          success: { (response) in
                                            if let entitiesMovieSerie: [EntityMixMovieSerie] = response as? [EntityMixMovieSerie] {
                                                self.entityMovieSerieArray = self.entityMovieSerieArray + entitiesMovieSerie
                                                self.numberOfItemsPerSection = self.entityMovieSerieArray.count
                                                self.filteredMovieSerieArray = self.entityMovieSerieArray
                                                self.parameterPage = entitiesMovieSerie[0].page
                                                if !scrolling { self.showOrHiddenComponents(showOrHidden: false) }
                                                self.uiCollectionView.reloadData()
                                            } else if let message: String = response as? String {
                                                self.uiLabelMessage.text = message
                                                if !scrolling { self.showOrHiddenComponents(showOrHidden: true) }
                                            }
                                            
                                            if !scrolling {
                                                Functions.dissmissActivityIndicatorView()
                                            } else {
                                                self.uiCollectionView.bottomRefreshControl?.endRefreshing()
                                            }
        }) { (message) in
            Functions.dissmissActivityIndicatorView()
            Functions.informationMessage(uiViewController: self, message: message)
        }
    }

}

//MARK: - UIScrollViewDelegate.

extension VCMixMovieSerie: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.uiSearchController.searchBar.endEditing(true)
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource.

extension VCMixMovieSerie: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        (cell.viewWithTag(1) as! UILabel).text = ((self.filteredMovieSerieArray[indexPath.row])).title
        (cell.viewWithTag(2) as! UIImageView).af_setImage(withURL: URL(string: (((self.filteredMovieSerieArray[indexPath.row])).poster!))!,
                                                          placeholderImage: UIImage(named: String().placeholderImageName))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: EnumSegues.segueMixDetail,
                          sender: self.filteredMovieSerieArray[indexPath.row])
    }

}

//MARK: - UISearchResultsUpdating, UISearchBarDelegate.

extension VCMixMovieSerie: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText: String = searchController.searchBar.text, !searchText.isEmpty {
            self.filteredMovieSerieArray = self.entityMovieSerieArray.filter({ (data) -> Bool in
                return (data as EntityMixMovieSerie).title.lowercased().contains(searchText.lowercased())
            })
        } else {
            self.filteredMovieSerieArray = self.entityMovieSerieArray
        }
        self.numberOfItemsPerSection = self.filteredMovieSerieArray.count
        self.uiCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.parameterPage.omDBSearchRestartParameter()
        self.entityMovieSerieArray.removeAll()
        self.requestMovieSerie(text: self.uiSearchController.searchBar.text,
                               type: self.uiSegmentControlMix.selectedSegmentIndex,
                               scrolling: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.uiSegmentControlMix.tintColor = UIColor.clear
        self.uiLabelMessage.text = EnumLocalizableString.MESSAGE_LABEL.localized
        self.parameterPage.omDBSearchRestartParameter()
        self.showOrHiddenComponents(showOrHidden: true)
        self.modifyConstraint(nsLayoutConstraint: self.nsLCSegmentControlMix,
                              constant: 0.0,
                              duration: 0.2)
        searchBar.showsCancelButton = false
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.uiSegmentControlMix.tintColor = UIColor.orange
        self.modifyConstraint(nsLayoutConstraint: self.nsLCSegmentControlMix,
                              constant: 30.0,
                              duration: 0.2)
        return true
    }

}

