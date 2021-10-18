//
//  AuthService.swift
//  AuthService
//
//  Created by Eliu Efraín Díaz Bravo on 06/09/21.
//

import UIKit
import Amplify
import AmplifyPlugins
import CoreLocation

class Service {
    static let shared = Service()
    private init() {}
    
    //MARK: - Register
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("DEBUG: Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("DEBUG: SignUp Complete")
                }
            case .failure(let error):
                print("DEBUG: An error occurred while registering a user \(error)")
                return
            }
        }
    }
    
    //MARK: - Login
    func signIn(username: String, password: String) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                print("DEBUG: Sign in succeeded")
            case .failure(let error):
                print("DEBUG: Sign in failed \(error)")
                
            }
        }
    }
    
    //MARK: - Logout
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("DEBUG: Successfully signed out")
            case .failure(let error):
                print("DEBUG: Sign out failed with error \(error)")
            }
        }
    }
    
    //MARK: - Fetching Data
    
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("User attributes - \(attributes)")
                
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
    }
    
    func fetchUID(completion: @escaping (String) -> Void) {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                let id = attributes.first { attribute in
                    attribute.key == AuthUserAttributeKey.unknown("sub")
                }
                completion(id!.value)
            case .failure(let error):
                print("DEBUG: Fetching user ID failed with error \(error)")
            }
        }
    }
    
    func fetchUserData(with uid: String ,completion: @escaping (User) -> Void) {
        Amplify.API.query(request: .get(User.self, byId: uid)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    guard let user = user else {
                        print("Could not find user")
                        return
                    }
                    completion(user)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with \(error)")
            }
        }
    }
    
    func fetchDrivers(by location: CLLocation, completion: @escaping ([DriverLocation]) -> Void) {
        
        Amplify.API.query(request: .paginatedList(DriverLocation.self)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let drivers):
                    print("Successfully retrieved list of drivers: \(drivers)")
                    
                    let closestDrivers = drivers.filter { driver in
                        let driverLocation = CLLocation(latitude: driver.latitude, longitude: driver.longitude)
                        if location.distance(from: driverLocation) < 1500 {
                            return true
                        }
                        return false
                    }
                    
                    completion(closestDrivers)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                    completion([DriverLocation]())
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
            }
        }
    }

    
    //MARK: - Session
    
    func fetchCurrentAuthSession() {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("DEBUG: Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("DEBUG: Fetch session failed with error \(error)")
            }
        }
    }
}
