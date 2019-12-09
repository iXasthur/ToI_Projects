//
//  ViewController.swift
//  ToI_L3
//
//  Created by Михаил Ковалевский on 07.11.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    private let binaryAlphabetString: String = "01"
    private let digitsAlphabetString: String = "0123456789"
    private let inputAlphabetString: String = " 0123456789"
    private let ruAlphabetString: String = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    private let enAlphabetString: String = "abcdefghijklmnopqrstuvwxyz"
    
    private let maxInputSize: Int = String(Int64.Magnitude.max).count-1
    private let PQ_LowestAllowedValue: UInt64 = 100
    
    private var initialFileURL: URL? = nil
    private var outputFileURL: URL? = nil
    
    @IBOutlet weak var Sign_Button: NSButton!
    
    @IBOutlet weak var P_TextField: NSTextField!
    @IBOutlet weak var Q_TextField: NSTextField!
    @IBOutlet weak var D_TextField: NSTextField!
    @IBOutlet weak var S_TextField: NSTextField!
    @IBOutlet weak var H_TextField: NSTextField!
    
    @IBOutlet weak var InitialFile_Label: NSTextField!
    @IBOutlet weak var ShowInitialFile_Button: NSButton!
    @IBOutlet weak var CheckDSInitialFile_Button: NSButton!
    @IBOutlet weak var OutputFile_Label: NSTextField!
    @IBOutlet weak var ShowOutputFile_Button: NSButton!
    @IBOutlet weak var CheckDSOutputFile_Button: NSButton!
    
    @IBAction func openDocument(_ sender: Any) {
        print("Opening document")
        let dialog: NSOpenPanel = NSOpenPanel()
        dialog.title = "Choose file to open"
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK {
            if dialog.url != nil {
                initialFileURL = dialog.url
                outputFileURL = nil
                InitialFile_Label.stringValue = "Initial File: \(initialFileURL!.lastPathComponent)"
                ShowInitialFile_Button.isHidden = false
                CheckDSInitialFile_Button.isHidden = false
                OutputFile_Label.stringValue = "Output File: nil"
                ShowOutputFile_Button.isHidden = true
                CheckDSOutputFile_Button.isHidden = true
                resetUI()
            } else {
                print("Error opening file")
            }
        } else {
            print("Closed openDocument dialog")
        }
        
    }
    
    private func check_PValue(value: UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = false
        if value != nil && value! > 0 {
            if euler64(of: value!) == value!-1 {
                TF.textColor = .green
                ret = true
            } else {
                TF.textColor = .red
            }
        }
        return ret
    }
    
    private func check_QValue(value: UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = false
        if value != nil && value! > 0 {
            if euler64(of: value!) == value!-1 {
                TF.textColor = .green
                ret = true
            } else {
                TF.textColor = .red
            }
        }
        return ret
    }
    
    private func check_DValue(value: UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = false
//        if value != nil && P_Value != nil {
//            if value! > 1 && value! < P_Value!-1 && fast_mod64(value: value!, power: euler64(of: P_Value!-1), mod: P_Value!-1) == 1 {
//                TF.textColor = .green
//                ret = true
//            } else {
//                TF.textColor = .red
//            }
//        } else {
//            TF.textColor = .red
//        }
        return ret
    }
    
    private func check_RValue(value: UInt64?, TF_P:NSTextField, TF_Q:NSTextField) -> Bool {
            var ret: Bool = false
    //        if value != nil && P_Value != nil {
    //            if value! > 1 && value! < P_Value!-1 && fast_mod64(value: value!, power: euler64(of: P_Value!-1), mod: P_Value!-1) == 1 {
    //                TF.textColor = .green
    //                ret = true
    //            } else {
    //                TF.textColor = .red
    //            }
    //        } else {
    //            TF.textColor = .red
    //        }
            return ret
        }
    
    @IBAction func initiateSignatureAlgorithm(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        switch button.identifier {
        case Sign_Button.identifier:
            print("Encryption button tapped")
            var check: Bool = true
            let P_Value: UInt64? = UInt64(P_TextField.stringValue)
            let Q_Value: UInt64? = UInt64(Q_TextField.stringValue)
            let D_Value: UInt64? = UInt64(D_TextField.stringValue)
            let R_Value: UInt64? = (P_Value ?? 0) * (Q_Value ?? 0)
            
            // Functions must be called first
            check = check_PValue(value: P_Value, TF: P_TextField) && check
            check = check_QValue(value: Q_Value, TF: Q_TextField) && check
            check = check_DValue(value: D_Value, TF: D_TextField) && check
            check = check && check_RValue(value: R_Value, TF_P: P_TextField, TF_Q: Q_TextField)
            
            if check {
                print("Initiating encryption")
                print("P:",P_Value!)
                print("Q:",Q_Value!)
                print("D:",D_Value!)
                print("R:",R_Value!)
                
            }
        default:
            print("> Invalid button in func initiateElGamalAlgorithm()!")
            print("> NSButton:    \(button)")
            if button.identifier != nil {
                print("> Identifier:  \(String(describing: button.identifier!))")
            } else {
                print("> Identifier:  nil")
            }
        }
    }
    
    @IBAction func showFileInDecimal(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        switch button.identifier {
        case ShowInitialFile_Button.identifier:
            print("Show initial file button tapped")
            if initialFileURL != nil {
                let outputVC: OutputViewController = OutputViewController()
                outputVC.updateFileURL(_url: initialFileURL!)
                outputVC.createStrings()
                self.presentAsModalWindow(outputVC)
            } else {
                print("Unable to show file: initialFileURL is nil")
            }
        case ShowOutputFile_Button.identifier:
            print("Show output file button tapped")
            if outputFileURL != nil {
                let outputVC: OutputViewController = OutputViewController()
                outputVC.updateFileURL(_url: outputFileURL!)
                outputVC.createStrings()
                self.presentAsModalWindow(outputVC)
            } else {
                print("Unable to show file: initialFileURL is nil")
            }
        default:
            print("> Invalid Button in func showFileInDecimal()!")
            print("> NSButton:    \(button)")
            if button.identifier != nil {
                print("> Identifier:  \(String(describing: button.identifier!))")
            } else {
                print("> Identifier:  nil")
            }
        }
    }
    
    @IBAction func checkRSADS(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        switch button.identifier {
        case CheckDSInitialFile_Button.identifier:
            print("Check DS of initial file button tapped")
            if initialFileURL != nil {
                
            } else {
                print("Unable to check DS of file: initialFileURL is nil")
            }
        case CheckDSOutputFile_Button.identifier:
            print("Check DS of output file button tapped")
            if outputFileURL != nil {
                
            } else {
                print("Unable to check DS of file: initialFileURL is nil")
            }
        default:
            print("> Invalid Button in func checkRSADS()!")
            print("> NSButton:    \(button)")
            if button.identifier != nil {
                print("> Identifier:  \(String(describing: button.identifier!))")
            } else {
                print("> Identifier:  nil")
            }
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField: NSTextField = obj.object as? NSTextField else {
            return
        }
        
        switch textField.identifier {
        case P_TextField.identifier:
            print("Edited P_TextField")
            
            textField.textColor = .white
            
            if textField.stringValue.count > maxInputSize {
                textField.stringValue.removeLast()
            }
            textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        case Q_TextField.identifier:
            print("Edited Q_TextField")
            
            textField.textColor = .white
            
            if textField.stringValue.count > maxInputSize {
                textField.stringValue.removeLast()
            }
            textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        case D_TextField.identifier:
            print("Edited D_TextField")
            
            textField.textColor = .white
            
            if textField.stringValue.count > maxInputSize {
                textField.stringValue.removeLast()
            }
            textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        default:
            print("> Invalid TextField in func controlTextDidChange()!")
            print("> NSTextField: \(textField)")
            if textField.identifier != nil {
                print("> Identifier:  \(String(describing: textField.identifier!))")
            } else {
                print("> Identifier:  nil")
            }
        }
        
        if !P_TextField.stringValue.isEmpty && !Q_TextField.stringValue.isEmpty && !D_TextField.stringValue.isEmpty {
            Sign_Button.isEnabled = true
        } else {
            Sign_Button.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDelegates()
        prepareUI()
//        resetUI()
    }
    
    private func setupDelegates() {
        P_TextField.delegate = self
        Q_TextField.delegate = self
        D_TextField.delegate = self
    }
        
    private func prepareUI() {
        P_TextField.isEnabled = false
        Q_TextField.isEnabled = false
        D_TextField.isEnabled = false
        
        Sign_Button.isEnabled = false
        
        ShowOutputFile_Button.isHidden = true
        ShowInitialFile_Button.isHidden = true
        
        CheckDSOutputFile_Button.isHidden = true
        CheckDSInitialFile_Button.isHidden = true
    }
    
    private func resetUI() {
        P_TextField.isEnabled = true
        Q_TextField.isEnabled = true
        D_TextField.isEnabled = true
        
        P_TextField.stringValue = ""
        Q_TextField.stringValue = ""
        D_TextField.stringValue = ""
        
        Sign_Button.isEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

