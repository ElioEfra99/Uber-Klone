//
//  File.swift
//  File
//
//  Created by Eliu Efraín Díaz Bravo on 03/08/21.
//

import UIKit
import Amplify

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
            ]
        )
        
        attributedTitle.append(
            NSAttributedString(
                string: "Sign Up",
                attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
                ]
            )
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleShowSignUp() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Amplify.Auth.signIn(username: email, password: password) { result in
            switch result {
            case .success:
                
                DispatchQueue.main.async {
                    guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
                    
                    controller.configureUI()
                    self.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("DEBUG: SignIn Failed with error: \(error)")
            }
        }
        
    }
    
    //MARK: - Helper Functions
    
    func setupUI() {
        setupNavigationBar()
        
        let safeArea = view.safeAreaLayoutGuide
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(titleLabel)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(stack)
        
        titleLabel.anchor(top: safeArea.topAnchor)
        titleLabel.centerX(inView: view)
        
        dontHaveAccountButton.anchor(bottom: safeArea.bottomAnchor, height: 32)
        dontHaveAccountButton.centerX(inView: view)
        
        stack.anchor(top: titleLabel.bottomAnchor, left: safeArea.leftAnchor, right: safeArea.rightAnchor,
                     paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        
        view.backgroundColor = .backgroundColor
        
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    
}
