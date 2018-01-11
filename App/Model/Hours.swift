//
//  Hours.swift
//
//  Created by Philip Starner on 1/11/18
//  Copyright (c) Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Hours {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let isOpenNow = "is_open_now"
    static let open = "open"
    static let hoursType = "hours_type"
  }

  // MARK: Properties
  public var isOpenNow: Bool? = false
  public var open: [Open]?
  public var hoursType: String?

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
    isOpenNow = json[SerializationKeys.isOpenNow].boolValue
    if let items = json[SerializationKeys.open].array { open = items.map { Open(json: $0) } }
    hoursType = json[SerializationKeys.hoursType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.isOpenNow] = isOpenNow
    if let value = open { dictionary[SerializationKeys.open] = value.map { $0.dictionaryRepresentation() } }
    if let value = hoursType { dictionary[SerializationKeys.hoursType] = value }
    return dictionary
  }

}
