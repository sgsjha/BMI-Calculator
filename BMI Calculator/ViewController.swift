
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

    // Initialization
    var scrollView: UIScrollView!
    var contentView: UIView!
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
    var loginCommentLabel: UILabel!
    var authenticated = false

    // VIEW DID LOAD FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        showHideButton.setImage(UIImage(systemName: eyeImageName), for: .normal)
    }

    @objc func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Sign up error: \(error.localizedDescription)")
                self.loginCommentLabel.text = "Sign up error: \(error.localizedDescription)" // show error
                self.loginCommentLabel.textColor = .red // Red color for error
                return
            }
            self.loginCommentLabel.text = "Signup successful!"
            self.loginCommentLabel.textColor = .green // Green color for success
            self.authenticated = true
            self.retrieveBMIs()
        }
    }

    @objc func login(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                self.loginCommentLabel.text = "Login error: \(error.localizedDescription)"
                self.loginCommentLabel.textColor = .red // Red color for error
                return
            }
            self.loginCommentLabel.text = "Login successful!"
            self.loginCommentLabel.textColor = .green // Green color for success
            self.authenticated = true
            self.retrieveBMIs()
        }
    }

    @objc func calculateBMI(_ sender: UIButton) {
        if authenticated == true {
            
            guard let heightText = heightTextField.text, let weightText = weightTextField.text,
                  let height = Double(heightText), let weight = Double(weightText) else {
                resultLabel.text = "Please enter valid height and weight."
                return
            }

            let heightInMeters = height / 100 // convert to meters
            let bmi = weight / (heightInMeters * heightInMeters) // BMI Formula
            
            // Switch statement to determine BMI Range
            let comment: String
            switch bmi {
            case ..<18.5:
                comment = "Underweight"
            case 18.5..<24.9:
                comment = "Normal weight"
            case 25.0..<29.9:
                comment = "Overweight"
            default:
                comment = "Obese"
            }

            resultLabel.text = "Your BMI is \(String(format: "%.2f", bmi)) (\(comment))"

            saveBMI(bmi)
        }
        else {
            self.loginCommentLabel.text = "Please Login or signup to Calculate BMI"
            self.loginCommentLabel.textColor = .orange // Green color for success
        }
        
    }

    func saveBMI(_ bmi: Double) {
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(user.uid).child("bmiHistory")
        let bmiEntry = ["bmi": bmi, "timestamp": Date().timeIntervalSince1970] as [String : Any]
        ref.childByAutoId().setValue(bmiEntry) { error, _ in
            if let error = error {
                print("Error saving BMI: \(error.localizedDescription)")
            } else {
                self.retrieveBMIs()
            }
        }
    }

    func retrieveBMIs() {
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(user.uid).child("bmiHistory")
        ref.observeSingleEvent(of: .value) { snapshot in
            var bmiHistory = "BMI History:\n"
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let bmiEntry = snapshot.value as? [String: Any],
                   let bmi = bmiEntry["bmi"] as? Double,
                   let timestamp = bmiEntry["timestamp"] as? TimeInterval {
                    let date = Date(timeIntervalSince1970: timestamp)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    let dateString = dateFormatter.string(from: date)
                    bmiHistory += "Date: \(dateString), BMI: \(String(format: "%.2f", bmi))\n" // print BMI history
                }
            }
            self.retrievedBMILabel.text = bmiHistory
        }
    }
}
