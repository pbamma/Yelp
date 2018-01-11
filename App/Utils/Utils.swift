//
//  Utils.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utils {
    static func prettyJSONStringConversion(dict: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            let dataString = String(data: jsonData,encoding: String.Encoding.utf8)!
            return dataString
        } catch {
            print(error.localizedDescription)
            return "Could not parse JSON"
        }
    }
    
    static func prettyJSONStringConversion(data: Data) -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            
            let dataString = String(data: data,encoding: String.Encoding.utf8)!
            return dataString
        } catch {
            print(error.localizedDescription)
            return "Could not parse JSON"
        }
    }
    
    /// Simple time formatter
    /// GET https://api.yelp.com/v3/businesses/{id}
    /// :param: time - "1100"
    /// :return: String: "6:00 PM".
    static func fourDigitHourConverter(time: String?) -> String {
        guard let time = time, time.count == 4 else {
            return "XX:XX"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let date = dateFormatter.date(from: time)
        
        //let dateAsString = "6:35 PM"
        dateFormatter.dateFormat = "h:mm a"
        
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return "XX:XX"
    }
    
    static func getDayOfWeek()->Int {
        let todayDate = Date()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.component(Calendar.Component.weekday, from: todayDate)
    }
}

