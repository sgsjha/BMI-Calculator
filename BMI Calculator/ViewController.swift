//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Sarthak Jha on 26/06/2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
    }
    
    
}
