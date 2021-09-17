//
//  AuthService.swift
//  AuthService
//
//  Created by Eliu Efraín Díaz Bravo on 06/09/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class AuthService {
    static let shared = AuthService()
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
    
    //MARK: - Attributes
    
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("User attributes - \(attributes)")
                print(attributes[1].value)
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
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
