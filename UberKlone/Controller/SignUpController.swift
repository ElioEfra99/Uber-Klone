//
//  SignUpController.swift
//  SignUpController
//
//  Created by Eliu Efraín Díaz Bravo on 21/08/21.
//

import UIKit

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
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
        UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    
    private let fullNameTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
    
    
    
    private let passwordTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: false)
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
    
    func setupNavigationBar() {
        
    }
}
