// swiftlint:disable all
import Amplify
import Foundation

extension DriverLocations {
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
    let driverLocations = DriverLocations.keys
    
    model.pluralName = "DriverLocations"
    
    model.fields(
      .id(),
      .field(driverLocations.latitude, is: .required, ofType: .double),
      .field(driverLocations.longitude, is: .required, ofType: .double),
      .field(driverLocations.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(driverLocations.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}