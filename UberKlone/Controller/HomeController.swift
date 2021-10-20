//
//  HomeController.swift
//  HomeController
//
//  Created by Eliu Efraín Díaz Bravo on 09/09/21.
//

import UIKit
import Amplify
import MapKit

private let reuseIdentifier = "LocationCell"

class HomeController: UIViewController {
    //MARK: - Properties
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let locationInputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private final let locationInputViewHeight: CGFloat = 200
    private var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.locationInputView.user = self.user
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
        fetchUserData()
        fetchDrivers()
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
    
    func fetchUserData() {
        Service.shared.fetchUID { uid in
            Service.shared.fetchUserData(with: uid) { user in
                self.user = user
            }
        }
        
    }
    
    func fetchDrivers() {
        guard let userLocation = self.locationManager?.location else { return }
        
        Service.shared.fetchDrivers(by: userLocation) { drivers in
            
            if !drivers.isEmpty {
                Service.shared.fetchUserData(with: drivers.first!.id) { user in
                    var driver = user
                    driver.location = Location(latitude: drivers.first!.latitude, longitude: drivers.first!.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: driver.location!.latitude, longitude: driver.location!.longitude)
                    let annotation = DriverAnnotation(uid: driver.id, coordinate: coordinate)
                    self.mapView.addAnnotation(annotation)
                }
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
        locationInputActivationView.delegate = self
        
        locationInputActivationView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            self.locationInputActivationView.alpha = 1
        }
        
        configureTableView()
        
    }
    
    func configureMap() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            self.presentTableView()
        }

    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let tableViewHeight = view.frame.height - locationInputViewHeight
        
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: tableViewHeight)
    }
    
    func presentTableView() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.origin.y = self.locationInputViewHeight
        }
    }
    
}

//MARK: - Location Services

extension HomeController {
    func enableLocationServices() {
        switch locationManager?.authorizationStatus {
        case .notDetermined, .none:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        @unknown default:
            break
        }
    }
}

//MARK: - LocationInputActivationView Delegate methods

extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        locationInputActivationView.alpha = 0
        configureLocationInputView()
    }
}

//MARK: - LocationInputView Delegate methods

extension HomeController: LocationInputViewDelegate {
    
    func dimsissLocationInputView() {

        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.locationInputActivationView.alpha = 1
            }
        }
    }
    
}

//MARK: - Table View methods

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

}
