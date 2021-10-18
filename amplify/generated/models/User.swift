// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var accountType: Int
  public var email: String
  public var fullName: String
  public var location: Location?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      accountType: Int,
      email: String,
      fullName: String,
      location: Location? = nil) {
    self.init(id: id,
      accountType: accountType,
      email: email,
      fullName: fullName,
      location: location,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      accountType: Int,
      email: String,
      fullName: String,
      location: Location? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.accountType = accountType
      self.email = email
      self.fullName = fullName
      self.location = location
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}