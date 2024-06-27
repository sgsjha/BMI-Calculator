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
    
        var emailTextField: UITextField!
        var passwordTextField: UITextField!
        var retrievedBMILabel: UILabel!
        var heightTextField: UITextField!
        var weightTextField: UITextField!
        var resultLabel: UILabel!
        var signUpButton: UIButton!
        var loginButton: UIButton!
        var calculateButton: UIButton!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Initialize UI Elements
            emailTextField = UITextField()
            emailTextField.placeholder = "Email"
            emailTextField.borderStyle = .roundedRect
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emailTextField)
            
            passwordTextField = UITextField()
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = false
            passwordTextField.borderStyle = .roundedRect
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(passwordTextField)
            
            signUpButton = UIButton(type: .system)
            signUpButton.setTitle("Sign Up", for: .normal)
            signUpButton.addTarget(self, action: #selector(signUp(_:)), for: .touchUpInside)
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(signUpButton)
            
            loginButton = UIButton(type: .system)
            loginButton.setTitle("Login", for: .normal)
            loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginButton)
            
            retrievedBMILabel = UILabel()
            retrievedBMILabel.numberOfLines = 0
            retrievedBMILabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(retrievedBMILabel)
            
            heightTextField = UITextField()
            heightTextField.placeholder = "Height (cm)"
            heightTextField.borderStyle = .roundedRect
            heightTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(heightTextField)
            
            weightTextField = UITextField()
            weightTextField.placeholder = "Weight (kg)"
            weightTextField.borderStyle = .roundedRect
            weightTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(weightTextField)
            
            calculateButton = UIButton(type: .system)
            calculateButton.setTitle("Calculate BMI", for: .normal)
            calculateButton.addTarget(self, action: #selector(calculateBMI(_:)), for: .touchUpInside)
            calculateButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(calculateButton)
            
            resultLabel = UILabel()
            resultLabel.numberOfLines = 0
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(resultLabel)
            
            setupConstraints()
        }
        
        func setupConstraints() {
            NSLayoutConstraint.activate([
                emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
                passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
                signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                retrievedBMILabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
                retrievedBMILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                retrievedBMILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                heightTextField.topAnchor.constraint(equalTo: retrievedBMILabel.bottomAnchor, constant: 20),
                heightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                heightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                weightTextField.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 10),
                weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                calculateButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 10),
                calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 20),
                resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
