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
    private let locationManager = CLLocationManager()
    private let locationInputActivationView = LocationInputActivationView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AuthService.shared.signOutLocally()
        checkIfUserIsLoggedIn()
        enableLocationServices()
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
        configureMap()
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(locationInputActivationView)
        locationInputActivationView.centerX(inView: view)
        locationInputActivationView.anchor(top: safeArea.topAnchor, paddingTop: 32)
        locationInputActivationView.setDimensions(width: view.frame.width - 64, height: 50)
    }
    
    func configureMap() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
}

//MARK: - Location Services

extension HomeController: CLLocationManagerDelegate {
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use..")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        @unknown default:
            break
        }
    }
}
