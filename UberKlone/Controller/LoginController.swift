//
//  File.swift
//  File
//
//  Created by Eliu Efraín Díaz Bravo on 03/08/21.
//

import UIKit

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
        UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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
