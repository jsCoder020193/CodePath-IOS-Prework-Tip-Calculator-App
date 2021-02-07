//
//  ViewController.swift
//  CodePath IOS Prework Tip Calculator App
//
//  Created by SubbaLakshmi on 1/31/21.
//  Copyright © 2021 SubbaLakshmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipDisplayValueLabel: UILabel!
    
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var splitSlider: UISlider!
    
    @IBOutlet weak var splitValueLabel: UILabel!
    
    @IBOutlet weak var splitTipLabel: UILabel!
    
    @IBOutlet weak var splitTotalLabel: UILabel!
    
    var customTipAmount: UITextField!
    
    var defaultTipAmount: Double! = 0.15 //TODO
    
    var source: String! = "tipControl"
    
    var tip: Double! = 0
    var total: Double! = 0
    var bill: Double! = 8
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Make user enter bill amount first
        billAmountTextField.becomeFirstResponder()
        
        //setting color to tip control
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        tipControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        tipControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let b = defaults.double(forKey: "billKey")
        if(b != 0){
            bill = b
            billAmountTextField.text = String(bill)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willTerminateNotification, object: nil)
    }
    
     @objc func saveData(notification:NSNotification) {
         // Save your data here
        defaults.set(bill, forKey: "billKey")

     }
//  Calculate as the user types in bill amount
    @IBAction func didBillAmountChange2(_ sender: Any) {
        calculateTipAmount()
    }
    
    func calculateTipAmount(){
        //      Get bill amount
        bill = Double(billAmountTextField.text!) ?? 0
                
        //      Get total tip
        let tipPercentages = [0.15,0.18,0.2]
        var tipDisplayValueLabelText: String! = ""
        
        if(bill != 0){
            if(source == "tipControl"){
                
                tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
                tipDisplayValueLabelText = tipControl.titleForSegment(at: tipControl.selectedSegmentIndex)
                
            }else if(source == "custom"){
                
                tip = Double(self.customTipAmount.text!)
                tipDisplayValueLabelText = "Custom"
                
            }else if(source == "tipSlider"){
                let tipPercent = Double(tipSlider.value/100)
                tip = bill * (tipPercent)
                tipDisplayValueLabelText = String(format: "%d",Int( tipSlider.value))+"%"
            }
        }

        total = bill + tip
        //      Update tip display value label
        tipDisplayValueLabel.text = tipDisplayValueLabelText
        //      Update tip amount label
        tipAmountLabel.text = String(format: "$%.2f", tip)
        //      Update total amount label
        totalLabel.text = String(format: "$%.2f", total)
        
        splitAmount()
    }
    
//  when tip control value changes
    @IBAction func calculateTip(_ sender: Any) {
        if(self.customTipAmount != nil){
            self.customTipAmount.text = ""
        }
        source = "tipControl"
        calculateTipAmount()
        view.endEditing(true)
    }
    
//  when tip slider value changes
    @IBAction func tipSliderValueChanged(_ sender: Any) {
        let roundedValue = round(tipSlider.value)
        tipSlider.value = roundedValue
        source = "tipSlider"
        calculateTipAmount()
        
    }

//  To display custom tip entering pop up alert
    @IBAction func enterCustomTip(_ sender: Any) {
        view.endEditing(true)
        tipControl.selectedSegmentIndex = -1
        displayForm(message: "Enter Tip Amount")
    }

//  Additional function to display custom tip entering pop up alert
    func displayForm(message:String){
        //create alert
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        //create cancel button
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
        
        //create save button
        let saveAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            
           //validation logic goes here
            // call calculateTip method
            if(self.customTipAmount.text != ""){
                self.source = "custom"
                self.calculateTipAmount()
            }
        }
        
        //add button to alert
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        //create first name textfield
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "$0.00"
            if(self.customTipAmount != nil && self.customTipAmount.text != ""){
                textField.text = self.customTipAmount.text
            }
            textField.keyboardType = UIKeyboardType.decimalPad
            self.customTipAmount = textField
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didSplitSliderValueChange(_ sender: Any) {
        let roundedValue = round(splitSlider.value)
        splitSlider.value = roundedValue
        splitValueLabel.text = String(format: "%d",Int(splitSlider.value))
        splitAmount()
    }
    
    func splitAmount(){
        
        let split = Double(splitSlider.value)
        let newTip: Double! = self.tip/split
        let newTotal: Double! = self.total/split
        
        //      Update tip amount label
        splitTipLabel.text = String(format: "$%.2f", newTip)
        //      Update total amount label
        splitTotalLabel.text = String(format: "$%.2f", newTotal)
    }
    
    @IBAction func didTapView(_ sender: Any) {
        if(billAmountTextField.isEditing){
            view.endEditing(true)
        }
    }
}
