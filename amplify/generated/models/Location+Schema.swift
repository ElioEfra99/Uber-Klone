// swiftlint:disable all
import Amplify
import Foundation

extension Location {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case latitude
    case longitude
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let location = Location.keys
    
    model.pluralName = "Locations"
    
    model.fields(
      .id(),
      .field(location.latitude, is: .required, ofType: .double),
      .field(location.longitude, is: .required, ofType: .double),
      .field(location.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(location.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}