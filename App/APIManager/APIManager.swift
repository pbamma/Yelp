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
    /// https://www.yelp.com/developers/documentation/v3/business_search?text=pizza&latitude=37.786882&longitude=-122.399972
    /// :param: callback: onCompletion 'Businesses' data.
    func getSearch(term:String, lat: Double, long: Double, onCompletion: ((_ businesses: [Business]?, _ error: Error?) -> Void)?) {
        let requestString = (Constants.YelpHost + "businesses/search" + "?term=\(term)" + "&latitude=\(lat)" + "&longitude=\(long)")
        
        Alamofire.request(requestString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseJSON { (response) in
            
            if let data = response.data {
                do {
                    let json = try JSON.init(data: data)
                    
                    let search = Search(json: json)
                    
                    onCompletion!(search.businesses, nil)
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
