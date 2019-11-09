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
    
    private let maxInputSize: Int = String(UInt64.Magnitude.max).count-1
    private let P_LowestAllowedValue: UInt64 = 255
    
    private var initialFileURL: URL? = nil
    private var outputFileURL: URL? = nil
    
    @IBOutlet weak var Encrypt_Button: NSButton!
    @IBOutlet weak var Decrypt_Button: NSButton!
    
    @IBOutlet weak var P_TextField: NSTextField!
    @IBOutlet weak var X_TextField: NSTextField!
    @IBOutlet weak var K_TextField: NSTextField!
    @IBOutlet weak var G_PopUpButton: NSPopUpButton!
    @IBOutlet weak var GGen_Button: NSButton!
    @IBOutlet weak var GCount_Label: NSTextField!
    
    @IBOutlet weak var InitialFile_Label: NSTextField!
    @IBOutlet weak var ShowInitialFile_Button: NSButton!
    @IBOutlet weak var OutputFile_Label: NSTextField!
    @IBOutlet weak var ShowOutputFile_Button: NSButton!
    
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
                OutputFile_Label.stringValue = "Output File: nil"
                ShowOutputFile_Button.isHidden = true
                resetUI()
            } else {
                print("Error opening file")
            }
        } else {
            print("Closed openDocument dialog")
        }
        
    }
    
    private func check_PValue(value: UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = true
        if value != nil {
            if euler64(of: value!)==value!-1{
                if value!>P_LowestAllowedValue{
                    TF.textColor = .green
                } else {
                    TF.textColor = .yellow
                }
            } else {
                TF.textColor = .red
                ret = false
            }
        }
        return ret
    }
    
    private func check_XValue(value: UInt64?, P_Value:UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = false
        if value != nil && P_Value != nil {
            if value! > 1 && value! < P_Value!-1 {
                TF.textColor = .green
                ret = true
            } else {
                TF.textColor = .red
            }
        } else {
            TF.textColor = .red
        }
        return ret
    }
    
    private func check_KValue(value: UInt64?, P_Value:UInt64?, TF:NSTextField) -> Bool {
        var ret: Bool = false
        if value != nil && P_Value != nil {
            if value! > 1 && value! < P_Value!-1 && fast_mod64(value: value!, power: euler64(of: P_Value!-1), mod: P_Value!-1) == 1 {
                TF.textColor = .green
                ret = true
            } else {
                TF.textColor = .red
            }
        } else {
            TF.textColor = .red
        }
        return ret
    }
    
    private func check_GValue(value: UInt64?) -> Bool {
        var ret: Bool = false
        if value != nil {
            ret = true
        }
        return ret
    }
    
    @IBAction func initiateElGamalAlgorithm(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        switch button.identifier {
        case Encrypt_Button.identifier:
            print("Encryption button tapped")
            var check: Bool = true
            let P_Value: UInt64? = UInt64(P_TextField.stringValue)
            let X_Value: UInt64? = UInt64(X_TextField.stringValue)
            let K_Value: UInt64? = UInt64(K_TextField.stringValue)
            let G_Value: UInt64? = UInt64(G_PopUpButton.titleOfSelectedItem ?? "")
            
            // P_Value was checked while generation of G Values
            // Problem with G also means problem with P
            if P_Value != nil && P_Value!<=P_LowestAllowedValue {
                check = false
            }
            // Functions must be called first
            check = check_XValue(value: X_Value, P_Value: P_Value, TF: X_TextField) && check
            check = check_KValue(value: K_Value, P_Value: P_Value, TF: K_TextField) && check
            check = check_GValue(value: G_Value) && check
            if check {
                print("Initiating encryption")
                print("P:",P_Value!)
                print("X:",X_Value!)
                print("K:",K_Value!)
                print("G:",G_Value!)
                
                
            }
        case Decrypt_Button.identifier:
            print("Decryption button tapped")
            
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
    
    @IBAction func generateGValues(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        if button.identifier == GGen_Button.identifier {
            print("Generate G values button tapped")
            G_PopUpButton.removeAllItems()
            let P: UInt64? = UInt64(P_TextField.stringValue)
            if check_PValue(value: P, TF: P_TextField) {
                let GValuesInt: [UInt64] = getPrimitiveRoots(of: P ?? 0)
                GValuesInt.forEach { (item) in
                    G_PopUpButton.addItem(withTitle: String(item))
                }
                
                if GValuesInt.count > 0 {
                    Encrypt_Button.isEnabled = true
                    Decrypt_Button.isEnabled = true
                }
                
                GCount_Label.stringValue = "Count: \(GValuesInt.count)"
            }
        } else {
            print("> Invalid button in func generateGValues()!")
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
            
        case ShowOutputFile_Button.identifier:
            print("Show output file button tapped")
            
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
    
    @IBAction func GValueSelectionDidChange(_ sender: NSPopUpButton) {
        if sender.identifier == G_PopUpButton.identifier {
            print("Changed G_PopUpButton value")
            
        } else {
            print("> Invalid PopUpButton in func GValueSelectionDidChange()!")
            print("> NSPopUpButton: \(sender)")
            if sender.identifier != nil {
                print("> Identifier:    \(String(describing: sender.identifier!))")
            } else {
                print("> Identifier:    nil")
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
            
            print("Cleared G_PopUpButton values")
            G_PopUpButton.removeAllItems()
            GCount_Label.stringValue = "Count: 0"
            
            print("Disabled Encrypt_Button and Decrypt_Button")
            Encrypt_Button.isEnabled = false
            Decrypt_Button.isEnabled = false
            
            textField.textColor = .white
            
            if textField.stringValue.count > maxInputSize {
                textField.stringValue.removeLast()
            }
            textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        case X_TextField.identifier:
            print("Edited X_TextField")
            
            textField.textColor = .white
            
            if textField.stringValue.count > maxInputSize {
                textField.stringValue.removeLast()
            }
            textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        case K_TextField.identifier:
            print("Edited K_TextField")
            
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
        X_TextField.delegate = self
        K_TextField.delegate = self
    }
        
    private func prepareUI() {
        P_TextField.isEnabled = false
        X_TextField.isEnabled = false
        K_TextField.isEnabled = false
        
        G_PopUpButton.removeAllItems()
        G_PopUpButton.isEnabled = false
        
        GGen_Button.isEnabled = false
        GCount_Label.isHidden = true
        
        Encrypt_Button.isEnabled = false
        Decrypt_Button.isEnabled = false
        
        ShowOutputFile_Button.isHidden = true
        ShowInitialFile_Button.isHidden = true
    }
    
    private func resetUI() {
        P_TextField.isEnabled = true
        X_TextField.isEnabled = true
        K_TextField.isEnabled = true
        
        P_TextField.stringValue = ""
        X_TextField.stringValue = ""
        K_TextField.stringValue = ""
        
        G_PopUpButton.removeAllItems()
        G_PopUpButton.isEnabled = true
        
        GGen_Button.isEnabled = true
        GCount_Label.isHidden = false
        
        Encrypt_Button.isEnabled = false
        Decrypt_Button.isEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

