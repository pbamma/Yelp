//
//  SearchViewController.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MapKit

class SearchViewController: UIViewController {

    @IBOutlet weak var blurContainer: UIView!
    var blurContainerEffectView: UIVisualEffectView?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var businesses:[CDBusiness]?
    var selectedBusiness:CDBusiness?
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    
    @IBOutlet weak var tableView: UITableView!
    var searchTerms:[CDSearchTerm]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startLocating()
        self.setupSearchBarView()
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupBlurView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLocating() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //Save Battery!  our location accuracy doesn't have to be all that accurate.
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            vc.title = "Detail"
            vc.business = self.selectedBusiness
        }
     }
    
    func setupSearchBarView() {
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.backgroundImage = UIImage()
    }
    
    func setupBlurView() {
        //add blur to container
        if self.blurContainerEffectView == nil {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            self.blurContainerEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurContainerEffectView!.frame = view.bounds
            self.blurContainerEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            self.blurContainer.insertSubview(self.blurContainerEffectView!, at: 0)
        }
    }
     
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let business = self.businesses {
            return business.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        if let business = self.businesses?[indexPath.item] {
            cell.loadModel(business: business)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedBusiness = self.businesses![indexPath.item]
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let terms = self.searchTerms {
            return terms.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let terms = self.searchTerms {
            cell.textLabel?.text = terms[indexPath.item].id
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let terms = self.searchTerms {
            self.searchBar.text = terms[indexPath.item].id
        }
        self.searchBar.becomeFirstResponder()
        showBookmarks(show: false)
    }
    
    func showBookmarks(show: Bool) {
        if show {
            self.searchTerms = DatabaseManager.sharedInstance.fetchSearchTerms()
            self.tableView.reloadData()
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 0
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: UISearchBarDelegate methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if let searchTerm = self.searchBar.text?.lowercased() {
            if let lat = UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_LATITUDE) as? Double, let long = UserDefaults.standard.value(forKey: Constants.USER_DEFAULT_LONGITUDE) as? Double {
                // check our database for this search at this location...
                //... if we've done the search before DO NOT MAKE THE API CALL
                //... users like snappy apps
                let isPreviousSearch = DatabaseManager.sharedInstance.isPreviousSearch(term: searchTerm, lat: lat, long: long)
                
                if isPreviousSearch {
                    print("We've stored this search so FAST display!")
                    self.businesses = DatabaseManager.sharedInstance.fetchBusinesses(searchTermID: searchTerm)?.sorted(by: { $0.id! < $1.id! })
                    self.collectionView.reloadData()
                } else {
                    APIManager.sharedInstance.getSearch(term: searchTerm, lat: lat, long: long) { (businesses: [Business]?, error: Error?) in
                        if let _ = businesses {
                            self.businesses = DatabaseManager.sharedInstance.fetchBusinesses(searchTermID: searchTerm)?.sorted(by: { $0.id! < $1.id! })
                            self.collectionView.reloadData()
                        } else {
                            self.showAlert(title: "Sorry!", message: "No businesses returned from this search.  Please make sure you're connected to the Internet.")
                            
                            if let error = error {
                                print("Error: \(error)")
                            }
                        }
                    }
                }
                
            } else {
                self.showAlert(title: "Sorry!", message: "Your location hasn't been refined.  Make sure the settings for this app allows location.")
            }
        } else {
            self.showAlert(title: "Sorry!", message: "Please enter text in the search!")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let isHidden = tableView.alpha == 0
        showBookmarks(show: isHidden)
    }
}

//MARK: CLLocationManagerDelegate methods
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        self.currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        if let location = location {
            print("current location lat: \(location.coordinate.latitude)  lon: \(location.coordinate.longitude)")
            UserDefaults.standard.set(location.coordinate.latitude, forKey: Constants.USER_DEFAULT_LATITUDE)
            UserDefaults.standard.set(location.coordinate.longitude, forKey: Constants.USER_DEFAULT_LONGITUDE)
        }

    }
}
