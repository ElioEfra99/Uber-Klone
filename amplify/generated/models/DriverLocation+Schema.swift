// swiftlint:disable all
import Amplify
import Foundation

extension DriverLocation {
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
    let driverLocation = DriverLocation.keys
    
    model.pluralName = "DriverLocations"
    
    model.fields(
      .id(),
      .field(driverLocation.latitude, is: .required, ofType: .double),
      .field(driverLocation.longitude, is: .required, ofType: .double),
      .field(driverLocation.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(driverLocation.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}