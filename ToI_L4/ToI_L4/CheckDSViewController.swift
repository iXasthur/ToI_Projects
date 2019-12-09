//
//  CheckDSViewController.swift
//  ToI_L4
//
//  Created by Михаил Ковалевский on 09.12.2019.
//  Copyright © 2019 Михаил Ковалевский. All rights reserved.
//

import Cocoa

class CheckDSViewController: NSViewController {
    
    private let signatureAlphabetString: String = "0123456789"

    private var FILE_URL: URL!
    
    @IBOutlet weak var stateLabel: NSTextField!
    @IBOutlet weak var mainTF: NSTextField!
    
    private var stateColor: NSColor = .white
    
    private var slStr: String = ""
    private var tfStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        stateLabel.stringValue = slStr
        stateLabel.textColor = stateColor
        mainTF.stringValue = tfStr
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "FILE: " + FILE_URL.lastPathComponent
    }
    
    func updateFileURL(_url: URL){
        FILE_URL = _url
    }
    
    func checkDS(separator: Character, maxSignatureSize: Int, D: UInt64, R: UInt64, R_Euler: UInt64){
        do {
            var buffStr: String = try String(contentsOf: FILE_URL)
            if let pos: String.Index = buffStr.lastIndex(of: separator) {
                let signatureSize: Int = buffStr.distance(from: pos, to: buffStr.endIndex) - 1
                if signatureSize > 0 && signatureSize <= maxSignatureSize {
                    var signatureStr: String = String(buffStr[buffStr.index(after: pos)..<buffStr.endIndex])
                    signatureStr = signatureStr.filter{signatureAlphabetString.contains($0)}
                    if signatureStr.count == signatureSize {
                        buffStr.removeLast(signatureSize+1)
                        let H: UInt64 = BSUIRHash64(of: buffStr, R: R)
                        // Max size of R_Euler is 8 digits so it's normal to convert it to Int64
                        // The same with D
                        let E: UInt64 = UInt64(euclid_ex64(a: Int64(R_Euler), b: Int64(D))[1])
                        let M: UInt64 = fast_mod64(value: UInt64(signatureStr)!, power: E, mod: R)
                        
                        tfStr = " m\'   = \(H)\n m    = \(M)\n"
                        tfStr = tfStr + " R    = \(R)\n f(R) = \(R_Euler)\n"
                        tfStr = tfStr + " D    = \(D)\n e    = \(E)\n"
                        tfStr = tfStr + " S    = \(signatureStr)\n"
                        
                        if H == M {
                            slStr = "RSA SIGNATURE IS VALID (m = m\')"
                            stateColor = .green
                        } else {
                            slStr = "RSA SIGNATURE IS INVALID (m != m\')"
                            stateColor = .red
                        }
                        
                    } else {
                        slStr = "RSA SIGNATURE DOES NOT EXIST"
                        tfStr = ""
                    }
                } else {
                    slStr = "RSA SIGNATURE DOES NOT EXIST"
                    tfStr = ""
                }
            } else {
                slStr = "RSA SIGNATURE DOES NOT EXIST"
                tfStr = ""
            }
        } catch let err {
            print(err)
            slStr = "UNABLE TO READ RSA SIGNATURE (INVALID FILE)"
            tfStr = ""
        }
    }
    
}
