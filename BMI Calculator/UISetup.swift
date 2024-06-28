//
//  UISetup.swift
//  BMI Calculator
//
//  Created by Sarthak Jha on 28/06/2024.
//

import Foundation
import UIKit
import Firebase


extension ViewController {
    
    func setupUI() {
        // Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Content View
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Background Color
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

        // Welcome Label
        welcomeLabel = UILabel()
        welcomeLabel.text = "BMI CALCULATOR"
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(welcomeLabel)

        // Email Text Field
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        contentView.addSubview(emailTextField)

        // Password Text Field
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .oneTimeCode // disables auto choose strong password
        contentView.addSubview(passwordTextField)

        // Show/Hide Password Button
        showHideButton = UIButton(type: .system)
        showHideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showHideButton.tintColor = .black
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(showHideButton)

        // Login Comment Label
        loginCommentLabel = UILabel()
        loginCommentLabel.text = ""
        loginCommentLabel.font = UIFont.systemFont(ofSize: 12)
        loginCommentLabel.textColor = .red
        loginCommentLabel.numberOfLines = 0
        loginCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginCommentLabel)

        // Sign Up Button
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signUpButton)

        // Login Button
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)

        // Retrieved BMI Label
        retrievedBMILabel = UILabel()
        retrievedBMILabel.text = "BMI History:"
        retrievedBMILabel.font = UIFont.systemFont(ofSize: 16)
        retrievedBMILabel.numberOfLines = 0
        retrievedBMILabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(retrievedBMILabel)

        // Height Text Field
        heightTextField = UITextField()
        heightTextField.placeholder = "Height (cm)"
        heightTextField.borderStyle = .roundedRect
        heightTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(heightTextField)

        // Weight Text Field
        weightTextField = UITextField()
        weightTextField.placeholder = "Weight (kg)"
        weightTextField.borderStyle = .roundedRect
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weightTextField)

        // Calculate BMI Button
        calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Calculate BMI", for: .normal)
        calculateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        calculateButton.backgroundColor = UIColor(red: 0.95, green: 0.2, blue: 0.3, alpha: 1.0)
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.layer.cornerRadius = 8
        calculateButton.addTarget(self, action: #selector(calculateBMI(_:)), for: .touchUpInside)
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calculateButton)

        // Result Label
        resultLabel = UILabel()
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resultLabel)

        // Constraints
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Constraints for emailTextField
            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Constraints for passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Show/Hide Password Button
            showHideButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            showHideButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
            
            // Login Comment Label
            loginCommentLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginCommentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginCommentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: loginCommentLabel.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: loginCommentLabel.bottomAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 40),

            // Retrieved BMI Label
            retrievedBMILabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            retrievedBMILabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            retrievedBMILabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Height Text Field
            heightTextField.topAnchor.constraint(equalTo: retrievedBMILabel.bottomAnchor, constant: 20),
            heightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Weight Text Field
            weightTextField.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 10),
            weightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Calculate BMI Button
            calculateButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 40),

            // Result Label
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    
}

