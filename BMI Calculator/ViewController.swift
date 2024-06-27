//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Sarthak Jha on 26/06/2024.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
        var welcomeLabel: UILabel!
        var emailTextField: UITextField!
        var passwordTextField: UITextField!
        var showHideButton: UIButton!
        var retrievedBMILabel: UILabel!
        var heightTextField: UITextField!
        var weightTextField: UITextField!
        var resultLabel: UILabel!
        var signUpButton: UIButton!
        var loginButton: UIButton!
        var calculateButton: UIButton!
    
       

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
            // Initialize UI Elements
            
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) // Light gray background
        
        // Welcome Label
        welcomeLabel = UILabel()
        welcomeLabel.text = "BMI CALCULATOR"
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        // Email Text Field
            emailTextField = UITextField()
            emailTextField.placeholder = "Email"
            emailTextField.borderStyle = .roundedRect
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            emailTextField.autocapitalizationType = .none
            emailTextField.autocorrectionType = .no
            view.addSubview(emailTextField)
            
            // Password Text Field
            passwordTextField = UITextField()
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.borderStyle = .roundedRect
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            passwordTextField.autocapitalizationType = .none
            passwordTextField.autocorrectionType = .no
            view.addSubview(passwordTextField)
        
        // Show/Hide Password Button
        showHideButton = UIButton(type: .system)
        showHideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showHideButton.tintColor = .black
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showHideButton)
        
        // Sign Up Button
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0) // Blue color
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        
        // Login Button
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0) // Dark blue color
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        // Retrieved BMI Label
        retrievedBMILabel = UILabel()
        retrievedBMILabel.text = "BMI History:"
        retrievedBMILabel.font = UIFont.systemFont(ofSize: 16)
        retrievedBMILabel.numberOfLines = 0
        retrievedBMILabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retrievedBMILabel)
        
        // Height Text Field
        heightTextField = UITextField()
        heightTextField.placeholder = "Height (cm)"
        heightTextField.borderStyle = .roundedRect
        heightTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heightTextField)
        
        // Weight Text Field
        weightTextField = UITextField()
        weightTextField.placeholder = "Weight (kg)"
        weightTextField.borderStyle = .roundedRect
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightTextField)
        
        // Calculate BMI Button
        calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Calculate BMI", for: .normal)
        calculateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        calculateButton.backgroundColor = UIColor(red: 0.95, green: 0.2, blue: 0.3, alpha: 1.0) // Red color
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.layer.cornerRadius = 8
        calculateButton.addTarget(self, action: #selector(calculateBMI(_:)), for: .touchUpInside)
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calculateButton)
        
        // Result Label
        resultLabel = UILabel()
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Constraints for emailTextField
            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Constraints for passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Show/Hide Password Button
            showHideButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            showHideButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Retrieved BMI Label
            retrievedBMILabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            retrievedBMILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retrievedBMILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Height Text Field
            heightTextField.topAnchor.constraint(equalTo: retrievedBMILabel.bottomAnchor, constant: 20),
            heightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Weight Text Field
            weightTextField.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 10),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Calculate BMI Button
            calculateButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
            calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculateButton.widthAnchor.constraint(equalToConstant: 180),
            calculateButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Result Label
            resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    
    @objc func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error signing up: \(error.localizedDescription)")
                } else {
                    print("User signed up: \(authResult?.user.email ?? "")")
                }
            }
    }
    
    
    @objc func login(_ sender: UIButton) {
       
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error logging in: \(error.localizedDescription)")
                } else {
                    print("User logged in: \(authResult?.user.email ?? "")")
                    self.retrieveBMIData()
                }
            }
    }
    
    
    
    
    @objc func calculateBMI(_ sender: UIButton) {
        guard let heightText = heightTextField.text, let heightCm = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText) else {
            resultLabel.text = "Please enter valid numbers."
            return
        }
        
        // Convert height from cm to m
               let heightM = heightCm / 100
               
               // BMI formula: weight (kg) / (height (m) * height (m))
               let bmi = weight / (heightM * heightM)
               resultLabel.text = String(format: "Your BMI is %.2f", bmi)
                saveBMIData(bmi: bmi)

        
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    //updated
    func saveBMIData(bmi: Double) {
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        
        //let ref = Database.database().reference()
        let ref = Database.database(url: "https://bmi-calculator-18785-default-rtdb.europe-west1.firebasedatabase.app").reference()
        if let userID = Auth.auth().currentUser?.uid {
            let bmiData = [
                "bmi": bmi,
                "timestamp": Date().timeIntervalSince1970
            ] as [String : Any]
            ref.child("users").child(userID).child("bmiHistory").childByAutoId().setValue(bmiData) { error, _ in
                if let error = error {
                    print("Error saving data: \(error.localizedDescription)")
                } else {
                    print("Data saved successfully")
                }
            }
        } else {
            print("User not authenticated")
        }
    }

    // updated
    func retrieveBMIData() {
        let ref = Database.database(url: "https://bmi-calculator-18785-default-rtdb.europe-west1.firebasedatabase.app").reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).child("bmiHistory").observeSingleEvent(of: .value, with: { snapshot in
                var bmiHistoryText = "BMI History:\n"
                print("Snapshot: \(snapshot)")
                if snapshot.exists() {
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot {
                            print("Child Snapshot: \(childSnapshot)")
                            if let dict = childSnapshot.value as? [String: Any] {
                                print("Dict: \(dict)")
                                if let bmi = dict["bmi"] as? Double,
                                   let timestamp = dict["timestamp"] as? TimeInterval {
                                    let date = Date(timeIntervalSince1970: timestamp)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateStyle = .short
                                    dateFormatter.timeStyle = .short
                                    let dateString = dateFormatter.string(from: date)
                                    bmiHistoryText += "BMI: \(bmi), Date: \(dateString)\n"
                                } else {
                                    print("Error parsing dict: \(dict)")
                                }
                            } else {
                                print("Error parsing child snapshot value as dict")
                            }
                        } else {
                            print("Error casting child snapshot")
                        }
                    }
                } else {
                    print("No data found")
                    bmiHistoryText += "No history available."
                }
                DispatchQueue.main.async {
                    self.retrievedBMILabel.text = bmiHistoryText
                    print("Updated retrievedBMILabel: \(self.retrievedBMILabel.text ?? "")")
                }
            }) { error in
                print("Error retrieving BMI history: \(error.localizedDescription)")
            }
        }
    }

    
    
}
