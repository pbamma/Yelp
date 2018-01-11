//
//  Businesses.swift
//
//  Created by Philip Starner on 1/10/18
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Business {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let coordinates = "coordinates"
    static let rating = "rating"
    static let price = "price"
    static let reviewCount = "review_count"
    static let displayPhone = "display_phone"
    static let location = "location"
    static let id = "id"
    static let categories = "categories"
    static let transactions = "transactions"
    static let distance = "distance"
    static let phone = "phone"
    static let imageUrl = "image_url"
    static let url = "url"
    static let isClosed = "is_closed"
  }

  // MARK: Properties
  public var name: String?
  public var coordinates: Coordinates?
  public var rating: Int?
  public var price: String?
  public var reviewCount: Int?
  public var displayPhone: String?
  public var location: Location?
  public var id: String?
  public var categories: [Categories]?
  public var transactions: [String]?
  public var distance: Float?
  public var phone: String?
  public var imageUrl: String?
  public var url: String?
  public var isClosed: Bool? = false

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    name = json[SerializationKeys.name].string
    coordinates = Coordinates(json: json[SerializationKeys.coordinates])
    rating = json[SerializationKeys.rating].int
    price = json[SerializationKeys.price].string
    reviewCount = json[SerializationKeys.reviewCount].int
    displayPhone = json[SerializationKeys.displayPhone].string
    location = Location(json: json[SerializationKeys.location])
    id = json[SerializationKeys.id].string
    if let items = json[SerializationKeys.categories].array { categories = items.map { Categories(json: $0) } }
    if let items = json[SerializationKeys.transactions].array { transactions = items.map { $0.stringValue } }
    distance = json[SerializationKeys.distance].float
    phone = json[SerializationKeys.phone].string
    imageUrl = json[SerializationKeys.imageUrl].string
    url = json[SerializationKeys.url].string
    isClosed = json[SerializationKeys.isClosed].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = coordinates { dictionary[SerializationKeys.coordinates] = value.dictionaryRepresentation() }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = price { dictionary[SerializationKeys.price] = value }
    if let value = reviewCount { dictionary[SerializationKeys.reviewCount] = value }
    if let value = displayPhone { dictionary[SerializationKeys.displayPhone] = value }
    if let value = location { dictionary[SerializationKeys.location] = value.dictionaryRepresentation() }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = categories { dictionary[SerializationKeys.categories] = value.map { $0.dictionaryRepresentation() } }
    if let value = transactions { dictionary[SerializationKeys.transactions] = value }
    if let value = distance { dictionary[SerializationKeys.distance] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    dictionary[SerializationKeys.isClosed] = isClosed
    return dictionary
  }

}
