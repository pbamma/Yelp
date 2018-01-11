//
//  Open.swift
//
//  Created by Philip Starner on 1/11/18
//  Copyright (c) Philip Starner. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Open {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let end = "end"
    static let isOvernight = "is_overnight"
    static let start = "start"
    static let day = "day"
  }

  // MARK: Properties
  public var end: String?
  public var isOvernight: Bool? = false
  public var start: String?
  public var day: Int?

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
    end = json[SerializationKeys.end].string
    isOvernight = json[SerializationKeys.isOvernight].boolValue
    start = json[SerializationKeys.start].string
    day = json[SerializationKeys.day].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = end { dictionary[SerializationKeys.end] = value }
    dictionary[SerializationKeys.isOvernight] = isOvernight
    if let value = start { dictionary[SerializationKeys.start] = value }
    if let value = day { dictionary[SerializationKeys.day] = value }
    return dictionary
  }

}
