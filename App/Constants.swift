//
//  Constants.swift
//  App
//
//  Created by Philip Starner on 1/10/18.
//  Copyright © 2018 Philip Starner. All rights reserved.
//
import Foundation
import UIKit


class Constants: NSObject {
    //constant colors used in app
    static let COLOR_ORANGE = UIColor(red: 232/255.0, green: 94/255.0, blue: 2/255.0, alpha: 1.0)
    static let COLOR_LIGHT_ORANGE = UIColor(red: 251/255.0, green: 159/255.0, blue: 2/255.0, alpha: 1.0)
    
    //yelp host urls
    
    static let YelpHost = "https://api.yelp.com/v3/"
    static let YelpAPIKey = "CKwPfdhqItAohpvP62oVhmKe7p__I7ls0wXRVnBuWvAH735dhKzYabsUT-voQen8k_AnfEVPO8BWnF23JNOwh7fV8G2mpcIj2RseXvwhfowmBrrqmueCZ9-sqmpWWnYx"
    
    //Authorization: Bearer <YOUR API KEY>
    static let headers = [
        "Authorization": "Bearer \(Constants.YelpAPIKey)",
    ]
    
    static let USER_DEFAULT_LATITUDE = "USER_DEFAULT_LATITUDE"
    static let USER_DEFAULT_LONGITUDE = "USER_DEFAULT_LONGITUDE"
    
    
    //MARK: - device structs
    struct ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH >= 1024.0
    }
}
