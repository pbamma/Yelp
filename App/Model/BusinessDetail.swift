//
//  BusinessDetail.swift
//
//  Created by Philip Starner on 1/11/18
//  Copyright (c) Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let isClaimed = "is_claimed"
    static let coordinates = "coordinates"
    static let rating = "rating"
    static let photos = "photos"
    static let price = "price"
    static let reviewCount = "review_count"
    static let displayPhone = "display_phone"
    static let hours = "hours"
    static let id = "id"
    static let categories = "categories"
    static let location = "location"
    static let transactions = "transactions"
    static let phone = "phone"
    static let imageUrl = "image_url"
    static let isClosed = "is_closed"
    static let url = "url"
  }

  // MARK: Properties
  public var name: String?
  public var isClaimed: Bool? = false
  public var coordinates: Coordinates?
  public var rating: Float?
  public var photos: [String]?
  public var price: String?
  public var reviewCount: Int?
  public var displayPhone: String?
  public var hours: [Hours]?
  public var id: String?
  public var categories: [Categories]?
  public var location: Location?
  public var transactions: [String]?
  public var phone: String?
  public var imageUrl: String?
  public var isClosed: Bool? = false
  public var url: String?

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
    isClaimed = json[SerializationKeys.isClaimed].boolValue
    coordinates = Coordinates(json: json[SerializationKeys.coordinates])
    rating = json[SerializationKeys.rating].float
    if let items = json[SerializationKeys.photos].array { photos = items.map { $0.stringValue } }
    price = json[SerializationKeys.price].string
    reviewCount = json[SerializationKeys.reviewCount].int
    displayPhone = json[SerializationKeys.displayPhone].string
    if let items = json[SerializationKeys.hours].array { hours = items.map { Hours(json: $0) } }
    id = json[SerializationKeys.id].string
    if let items = json[SerializationKeys.categories].array { categories = items.map { Categories(json: $0) } }
    location = Location(json: json[SerializationKeys.location])
    if let items = json[SerializationKeys.transactions].array { transactions = items.map { $0.stringValue } }
    phone = json[SerializationKeys.phone].string
    imageUrl = json[SerializationKeys.imageUrl].string
    isClosed = json[SerializationKeys.isClosed].boolValue
    url = json[SerializationKeys.url].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    dictionary[SerializationKeys.isClaimed] = isClaimed
    if let value = coordinates { dictionary[SerializationKeys.coordinates] = value.dictionaryRepresentation() }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = photos { dictionary[SerializationKeys.photos] = value }
    if let value = price { dictionary[SerializationKeys.price] = value }
    if let value = reviewCount { dictionary[SerializationKeys.reviewCount] = value }
    if let value = displayPhone { dictionary[SerializationKeys.displayPhone] = value }
    if let value = hours { dictionary[SerializationKeys.hours] = value.map { $0.dictionaryRepresentation() } }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = categories { dictionary[SerializationKeys.categories] = value.map { $0.dictionaryRepresentation() } }
    if let value = location { dictionary[SerializationKeys.location] = value.dictionaryRepresentation() }
    if let value = transactions { dictionary[SerializationKeys.transactions] = value }
    if let value = phone { dictionary[SerializationKeys.phone] = value }
    if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
    dictionary[SerializationKeys.isClosed] = isClosed
    if let value = url { dictionary[SerializationKeys.url] = value }
    return dictionary
  }

}
