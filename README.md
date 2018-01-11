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

# Architecture
- MVC-N (Modle-View-Controller-Network)
- Persistence - CoreData
- RESTful with Yelp backend
- Capabilities - Maps + CoreLocation

# Requirements
iOS 11.0+
Xcode 9.2+
Swift 4.0+

# Data Source

https://www.yelp.com/developers/documentation/v3


# Bonus points

Persist the search results locally for offline access.

