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
}

