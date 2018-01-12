//
//  APIManager.swift
//  Video
//
//  Created by Philip Starner on 11/8/16.
//  Copyright © 2016 Philip Starner. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager {
    static let sharedInstance = DatabaseManager()
    private init() {}
    
    //database entity elements
    private let kCDSearchTerm = "CDSearchTerm"
    private let kCDBusiness = "CDBusiness"
    
    func createOrUpdateSearchTerm(id: String, lat: Double, long: Double, business: [Business]?) {
        var searchTerm:CDSearchTerm
        
        //see if this is new search term
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDSearchTerm)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        if results.count > 0 {
            print("we've found an old search term")
            searchTerm = results[0] as! CDSearchTerm
            //we've found this search in our DB, the dump the old businesses in last search to new.
            if let businesses = searchTerm.business {
                searchTerm.removeFromBusiness(businesses)
            }
            
            DatabaseController.saveContext()
        } else {
            print("we're creating a new entity")
            searchTerm = NSEntityDescription.insertNewObject(forEntityName: kCDSearchTerm, into: DatabaseController.getContext()) as! CDSearchTerm
        }
        
        //continue with updating the businesses with the search term.
        searchTerm.id = id
        searchTerm.lat = lat
        searchTerm.long = long
        
        if let business = business {
            for biz in business {
                let cdBusiness = NSEntityDescription.insertNewObject(forEntityName: kCDBusiness, into: DatabaseController.getContext()) as! CDBusiness
                cdBusiness.id = biz.id
                cdBusiness.name = biz.name
                var theAddress = ""
                if let displayAddress = biz.location?.displayAddress {
                    for items in displayAddress {
                        theAddress += items + "\n"
                    }
                } else {
                    theAddress += "No Address" + "\n"
                }
                cdBusiness.address = theAddress
                cdBusiness.price = biz.price
                if let rating = biz.rating {
                    cdBusiness.rating = Float(rating)
                }
                cdBusiness.phone = biz.phone
                cdBusiness.imageURL = biz.imageUrl
                
                searchTerm.addToBusiness(cdBusiness)
            }
        }
        
        DatabaseController.saveContext()
    }
    
    func saveCurrent() {
        DatabaseController.saveContext()
    }
    
    func deleteSearchTermFromDatabase(managedObject: NSManagedObject) {
        //TODO: we need to do a video cleanup using deleteVideo method
        //cycle through all video url's in video project
        let context = DatabaseController.getContext()
        context.delete(managedObject)
        
        DatabaseController.saveContext()
    }
    
    func fetchSearchTerms() -> [CDSearchTerm]? {
        let fetchResult:NSFetchRequest<CDSearchTerm> = CDSearchTerm.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchResult)
            
            return searchResults as [CDSearchTerm]
        } catch {
            print("Problem Fetching Videos: \(error)")
        }
        
        return nil
    }
    
    func fetchBusinesses(searchTermID: String) -> [CDBusiness]? {
        //see if this is new search term
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDSearchTerm)
        fetchRequest.predicate = NSPredicate(format: "id = %@", searchTermID)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
            let searchTerm = results[0] as! CDSearchTerm
            if let businesses = searchTerm.business {
                return Array(businesses)
            } else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func fetchBusiness(businessID: String) -> CDBusiness? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDBusiness)
        fetchRequest.predicate = NSPredicate(format: "id = %@", businessID)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
            if let business = results[0] as? CDBusiness {
                return business
            } else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func updateBusinessDetail(businessID: String, business: BusinessDetail) {
        //see if this is new search term
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDBusiness)
        fetchRequest.predicate = NSPredicate(format: "id = %@", businessID)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
            if results.count > 0 {
                let cdBusiness = results[0] as! CDBusiness
                if let rating = business.rating {
                    cdBusiness.rating = rating
                }
                if let openNow = business.hours?[0].isOpenNow {
                    cdBusiness.isOpenNow = openNow
                }
                
                if let open = business.hours?[0].open {
                    let dayOfWeek = Utils.getDayOfWeek()
                    if dayOfWeek < open.count {
                        let today = open[dayOfWeek]
                        cdBusiness.hoursStart = Utils.fourDigitHourConverter(time: today.start)
                        cdBusiness.hoursEnd = Utils.fourDigitHourConverter(time: today.end)
                    }
                }
                
                DatabaseController.saveContext()
            }
            
        }
        catch {
            print("unable to update business: \(businessID)")
        }
    }
    
    func isBusinessUpdated(businessID: String) -> Bool {
        //see if this is new search term
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDBusiness)
        fetchRequest.predicate = NSPredicate(format: "id = %@", businessID)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
            if results.count > 0 {
                let cdBusiness = results[0] as! CDBusiness
                return cdBusiness.hoursStart != nil
            }
        }
        catch {
            return false
        }
        return false
    }
    
    func isPreviousSearch(term: String, lat: Double, long: Double) -> Bool {
        //see if this is new search term
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kCDSearchTerm)
        fetchRequest.predicate = NSPredicate(format: "id = %@", term)
        var results: [NSManagedObject] = []
        do {
            results = try DatabaseController.getContext().fetch(fetchRequest)
            if results.count > 0 {
                let cdSearch = results[0] as! CDSearchTerm
                //if search has been done in this location... it's a repeat
                
                //2 decimal precisions is about 1.1 km... so that is a good enough compare
                let storedLat = Double(round(100*cdSearch.lat)/100)
                let storedLong = Double(round(100*cdSearch.long)/100)
                let thisLat = Double(round(100*lat)/100)
                let thisLong = Double(round(100*long)/100)
                
                return storedLat == thisLat && storedLong == thisLong
            }
        }
        catch {
            return false
        }
        return false
    }
}
