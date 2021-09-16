//
//  LoginViewController.swift
//  Chat App
//
//  Created by Harvey Duperier on 9/8/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    /*private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "waveLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()*/
    
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let gradLayer: CAGradientLayer = {
        let gradLayer = CAGradientLayer()
        gradLayer.colors = [
            UIColor(red:0.2, green:0.42, blue:1, alpha:1).cgColor,
            UIColor(red:0.48, green:0.29, blue:1, alpha:1).cgColor
        ]
        return gradLayer
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor(red: 122/255, green: 75/255, blue: 1, alpha: 1).cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor(red: 122/255, green: 75/255, blue: 1, alpha: 1).cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor(red: 122/255, green: 75/255, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let welcomeText: UILabel = {
        let welcomeText = UILabel()
        welcomeText.text = "Welcome Back,"
        welcomeText.textColor = .white
        welcomeText.font = welcomeText.font.withSize(24.0)
        return welcomeText
    }()
    
    private let logInText: UILabel = {
        let logInText = UILabel()
        logInText.text = "Log In"
        logInText.textColor = .white
        logInText.font = UIFont.boldSystemFont(ofSize: 60)
        return logInText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Log In"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        navigationItem.rightBarButtonItem?.tintColor = .black
        // Adding Target for Log In Button
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //Adding ScrollView
        view.addSubview(scrollView)
        
        // Placing elements in ScrollView
        scrollView.addSubview(welcomeText)
        scrollView.addSubview(logInText)
        scrollView.layer.insertSublayer(gradLayer, at: 0)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        welcomeText.frame = CGRect(x: 20, y: 35, width: scrollView.width-20, height: 30)
        logInText.frame = CGRect(x: 20, y: welcomeText.bottom-10, width: scrollView.width-20, height: 90)
        gradLayer.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: (scrollView.height/3)-5)
        emailField.frame = CGRect(x: 20, y: (gradLayer.frame.size.height + gradLayer.frame.origin.y)+20, width: scrollView.width-60, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        loginButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        //Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to Log In User with Email: \(email)")
                return
            }
            let user = result.user
            print("Logged In: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter all information to log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Register User Account"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
