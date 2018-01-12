# iOS Take Home Excercise

* Register for and use the Yelp Fusion API https://www.yelp.com/developers/documentation/v3 ( https://www.yelp.com/developers/documentation/v3 ) ( https://www.yelp.com/developers/documentation/v3 ( https://www.yelp.com/developers/documentation/v3 ) ) to provide a simple search over their business listings.

* Please display search results as a grid of images that endlessly scrolls. (See attached screenshot)

* Store and display a list of past search queries

* **Bonus** - See Bonus points.

---------------------------------------------------------------------------------

# Major functions
- CoreLocation to get user current possition (stored in UserDefaults)
- AlamoFire to retrieve JSON data from Yelp API
- CoreData to store past results when offline
- HCSStarRatingView pod for star rating visual

# Architecture
- MVC-N (Modle-View-Controller-Network)
- Persistence - CoreData, (last location using UserDefaults minimally)
- RESTful with Yelp backend
- Capabilities - Maps + CoreLocation

# Requirements
iOS 11.0+
Xcode 9.2+
Swift 4.0+

# Data Source

https://www.yelp.com/developers/documentation/v3


# Review Testing
- if reviewer updates bundleID to something they own in app store, and reprovision, app can be tested on personal device.
- stored queries can be accessed through the bookmark icon in search bar.
- app should work minimally (no crashing) upon first load and no internet
- app should store results that can be reaccessed if offline
- app should use stored results to give user faster display
- app should update results if user has moved phone > 1.2 km away from last repeated search
- app does not cache images outside of SDWebImage natural built in functionality
- app should allow user to call business when phone is available.
- app should open maps app if business displays an address.

# Bonus points

- Persist the search results locally for offline access.
- Show a detail view of a business

