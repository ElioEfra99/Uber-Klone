//
//  HomeController.swift
//  HomeController
//
//  Created by Eliu Efraín Díaz Bravo on 09/09/21.
//

import UIKit
import Amplify
import MapKit

class HomeController: UIViewController {
    //MARK: - Properties
    private let mapView = MKMapView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AuthService.shared.signOutLocally()
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        Amplify.Auth.fetchAuthSession() { result in
            switch result {
            case .success(let session):
                if !(session.isSignedIn) {
                    DispatchQueue.main.async {
                        let nav = UINavigationController(rootViewController: LoginController())
                        if #available(iOS 13.0, *) {
                            nav.isModalInPresentation = true
                        }
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.configureUI()
                    }
                }
            case .failure(let error):
                print("DEBUG: Fetch session failed with error \(error)")
            }
        }
    }
    
    //MARK: - Helper
    func configureUI() {
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
    
}
