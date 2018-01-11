//
//  Location.swift
//
//  Created by Philip Starner on 1/10/18
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Location {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let state = "state"
    static let city = "city"
    static let address1 = "address1"
    static let address3 = "address3"
    static let address2 = "address2"
    static let displayAddress = "display_address"
    static let zipCode = "zip_code"
    static let country = "country"
  }

  // MARK: Properties
  public var state: String?
  public var city: String?
  public var address1: String?
  public var address3: String?
  public var address2: String?
  public var displayAddress: [String]?
  public var zipCode: String?
  public var country: String?

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
    state = json[SerializationKeys.state].string
    city = json[SerializationKeys.city].string
    address1 = json[SerializationKeys.address1].string
    address3 = json[SerializationKeys.address3].string
    address2 = json[SerializationKeys.address2].string
    if let items = json[SerializationKeys.displayAddress].array { displayAddress = items.map { $0.stringValue } }
    zipCode = json[SerializationKeys.zipCode].string
    country = json[SerializationKeys.country].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[SerializationKeys.state] = value }
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = address1 { dictionary[SerializationKeys.address1] = value }
    if let value = address3 { dictionary[SerializationKeys.address3] = value }
    if let value = address2 { dictionary[SerializationKeys.address2] = value }
    if let value = displayAddress { dictionary[SerializationKeys.displayAddress] = value }
    if let value = zipCode { dictionary[SerializationKeys.zipCode] = value }
    if let value = country { dictionary[SerializationKeys.country] = value }
    return dictionary
  }

}
