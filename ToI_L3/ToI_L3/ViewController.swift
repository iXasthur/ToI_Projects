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
                
                
            } else {
                print("Error opening file")
            }
        } else {
            print("Closed openDocument dialog")
        }
        
    }
    
    @IBAction func initiateElGamalAlgorithm(_ sender: Any) {
        guard let button: NSButton = sender as? NSButton else {
            return
        }
        
        switch button.identifier {
        case Encrypt_Button.identifier:
            print("Encryption button tapped")
            
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
        
//        if textField.stringValue.count > maxInputSize {
//            textField.stringValue.removeLast()
//        }
//        textField.stringValue = textField.stringValue.filter{inputAlphabetString.contains($0)}
        
        switch textField.identifier {
        case P_TextField.identifier:
            print("Edited P_TextField")
        case X_TextField.identifier:
            print("Edited X_TextField")
        case K_TextField.identifier:
            print("Edited K_TextField")
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
        for i:Int64 in 1...20 {
            print("\(i):",getPrimitiveRoots(of: i))
        }
        setupDelegates()
        prepareUI()
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

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

