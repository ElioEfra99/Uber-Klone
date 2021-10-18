// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case accountType
    case email
    case fullName
    case location
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.accountType, is: .required, ofType: .int),
      .field(user.email, is: .required, ofType: .string),
      .field(user.fullName, is: .required, ofType: .string),
      .belongsTo(user.location, is: .optional, ofType: Location.self, targetName: "userLocationId"),
      .field(user.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}