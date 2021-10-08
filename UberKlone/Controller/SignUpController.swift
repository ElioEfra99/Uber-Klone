//
//  SignUpController.swift
//  SignUpController
//
//  Created by Eliu Efraín Díaz Bravo on 21/08/21.
//

import UIKit
import Amplify

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    var location = LocationHandler.shared.locationManager.location
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.font = UIFont(name: "Avenir-Light", size: 36)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    
    private let fullNameTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
    
    
    
    private let passwordTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        sc.overrideUserInterfaceStyle = .dark
        return sc
    }()
    
    private let signupButton: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
            ]
        )
        
        attributedTitle.append(
            NSAttributedString(
                string: "Login",
                attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
                ]
            )
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        let accountType = accountTypeSegmentedControl.selectedSegmentIndex
        
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth.signUp(username: email, password: password, options: options) { result in
            
            switch result {
            case .success:
                print("DEBUG: User was registered")
                
                Amplify.Auth.signIn(username: email, password: password) { result in
                    
                    switch result {
                    case .success:
                        print("DEBUG: Sign in succeeded")
                        self.fetchNewUserAttributesWith(accountType: accountType, fullName: fullName, email: email)
                        
                    case .failure(let error):
                        print("DEBUG: Sign in failed \(error)")
                        
                    }
                }
                
            case .failure(let error):
                print("DEBUG: An error occurred while registering a user \(error)")
                return
            }
            
        }
    }
        
    
    //MARK: - Helper Functions
    
    func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            fullNameContainerView,
            passwordContainerView,
            accountTypeContainerView,
            signupButton,
            
        ])
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(stack)
        view.addSubview(alreadyHaveAccountButton)
        
        titleLabel.anchor(top: safeArea.topAnchor)
        titleLabel.centerX(inView: view)
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        stack.anchor(top: titleLabel.bottomAnchor, left: safeArea.leftAnchor,
                     right: safeArea.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        alreadyHaveAccountButton.anchor(bottom: safeArea.bottomAnchor, height: 32)
        alreadyHaveAccountButton.centerX(inView: view)
    }
    
    func createUser(_ user: User) {
        Amplify.API.mutate(request: .create(user)) { event in
            switch event {
            case .success(let result):
                
                switch result {
                case .success(let user):
                    print("DEBUG: Successfully created the user: \(user)")
                    if user.accountType == 1 {
                        guard let location = self.location else { return }
                        let driver = DriverLocations(id: user.id, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        
                        self.create(driverLocation: driver)
                        return
                    }
                    
                    self.showHomeController()
                    
                case .failure(let graphQLError):
                    // Probably delete recently created user, as creating a table with its data was not possible
                    print("DEBUG: Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError):
                print("DEBUG: Failed to create a user", apiError)
            }
        }
    }
    
    func create(driverLocation: DriverLocations) {
        Amplify.API.mutate(request: .create(driverLocation)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let driverLocation):
                    print("DEBUG: Successfully created the driver location: \(driverLocation)")
                    
                    self.showHomeController()
                                        
                case .failure(let graphQLError):
                    print("DEBUG: Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError):
                print("DEBUG: Failed to create driver location", apiError)
            }
        }
    }
    
    func fetchNewUserAttributesWith(accountType: Int, fullName: String, email: String) {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("DEBUG: User attributes - \(attributes)")
                
                let id = attributes.first { attribute in
                    attribute.key == AuthUserAttributeKey.unknown("sub")
                }
                
                let user = User(
                    id: id!.value, // At this point, it is guaranteed to have the new user signed up, signed in and retrieve a valid sub
                    accountType: accountType,
                    email: email,
                    fullName: fullName
                )
                
                self.createUser(user)
                
            case .failure(let error):
                print("DEBUG: Fetching user attributes failed with error \(error)")
            }
        }
    }
    
    func showHomeController() {
        print("nice")
        DispatchQueue.main.async {
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
            controller.configureUI()
            controller.fetchUserData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
