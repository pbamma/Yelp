//
//  FAIRAPIManager.swift
//  CarApp
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//
//  Yelp protocol:  GET https://api.yelp.com/v3/businesses/search
//                  GET https://api.yelp.com/v3/businesses/{id}
//  Search: https://www.yelp.com/developers/documentation/v3/business_search
//  Business: https://www.yelp.com/developers/documentation/v3/business

import Alamofire
import SwiftyJSON

class APIManager {
    
    //Singleton class to speak to whenever and whereever we need
    static var sharedInstance = APIManager()
    
    init() {
        //no local items to initialize yet.
    }
    

    
    /// get a list of businesses
    /// GET https://api.yelp.com/v3/businesses/search
    /// :param: term - a search term like 'pizza' or 'starbucks'.
    /// :param: lat, long - a location on earth to search around.
    /// :param: callback: onCompletion 'Businesses' data.
    func getSearch(term:String, lat: Double, long: Double, onCompletion: ((_ businesses: [Business]?, _ error: Error?) -> Void)?) {
        //format the term to work in the request string (no spaces!)
        if let escapedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let requestString = (Constants.YelpHost + "businesses/search" + "?term=\(escapedTerm)" + "&latitude=\(lat)" + "&longitude=\(long)")
            
            Alamofire.request(requestString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseJSON { (response) in
                
                if let data = response.data {
                    do {
                        let json = try JSON.init(data: data)
                        
                        let search = Search(json: json)
                        
                        //update the coreData
                        DatabaseManager.sharedInstance.createOrUpdateSearchTerm(id: term, lat: lat, long: long, business: search.businesses!)
                        
                        //make callback
                        onCompletion!(search.businesses, nil)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        onCompletion!(nil, error)
                    }
                } else {
                    print("Error: response data no good)")
                    onCompletion!(nil, nil)
                }
            }
        } else {
            print("Error: text escaping failed)")
            onCompletion!(nil, nil)
        }
        
    }
    
    /// get a business by id
    /// GET https://api.yelp.com/v3/businesses/{id}
    /// :param: id - a business id returned from a search
    /// :param: callback: onCompletion 'Businesses' data.
    func getBusiness(id:String, onCompletion: ((_ business: BusinessDetail?, _ error: Error?) -> Void)?) {
        let requestString = (Constants.YelpHost + "businesses/\(id)")
        
        Alamofire.request(requestString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseJSON { (response) in
            
            if let data = response.data {
                do {
                    let json = try JSON.init(data: data)
                    let detail = BusinessDetail(json: json)
                    onCompletion!(detail, nil)
                } catch {
                    print("error: \(error.localizedDescription)")
                    onCompletion!(nil, error)
                }
            } else {
                onCompletion!(nil, nil)
            }
        }
    }
    
}
