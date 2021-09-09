//
//  HomeController.swift
//  HomeController
//
//  Created by Eliu Efraín Díaz Bravo on 09/09/21.
//

import UIKit
import Amplify

class HomeController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        Amplify.Auth.fetchAuthSession() { result in
            switch result {
            case .success(let session):
                if session.isSignedIn {
                    print("DEBUG: User is Signed In")
                } else {
                    DispatchQueue.main.async {
                        let nav = UINavigationController(rootViewController: LoginController())
                        if #available(iOS 13.0, *) {
                            nav.isModalInPresentation = true
                        }
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("DEBUG: Fetch session failed with error \(error)")
            }
        }
    }
}
