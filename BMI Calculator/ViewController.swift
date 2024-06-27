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
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retrievedBMILabel: UILabel!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error signing up: \(error.localizedDescription)")
                } else {
                    print("User signed up: \(authResult?.user.email ?? "")")
                }
            }
    }
    
    
    @IBAction func login(_ sender: UIButton) {
       
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
    
    
    
    
    @IBAction func calculateBMI(_ sender: UIButton) {
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
