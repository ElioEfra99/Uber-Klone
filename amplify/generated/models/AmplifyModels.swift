// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "81afe6fe9e0b7381157d1fed9c7e1fe5"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Location.self)
    ModelRegistry.register(modelType: DriverLocation.self)
  }
}