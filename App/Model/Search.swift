//
//  Search.swift
//
//  Created by Philip Starner on 1/10/18
//  Copyright © 2018 Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Search {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let total = "total"
    static let region = "region"
    static let businesses = "businesses"
  }

  // MARK: Properties
  public var total: Int?
  public var region: Region?
  public var businesses: [Business]?

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
    total = json[SerializationKeys.total].int
    region = Region(json: json[SerializationKeys.region])
    if let items = json[SerializationKeys.businesses].array { businesses = items.map { Business(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = total { dictionary[SerializationKeys.total] = value }
    if let value = region { dictionary[SerializationKeys.region] = value.dictionaryRepresentation() }
    if let value = businesses { dictionary[SerializationKeys.businesses] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
