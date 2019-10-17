//
//  DetailsViewControllerGeffe.swift
//  ToI_L1-2
//
//  Created by Михаил Ковалевский on 16.10.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Cocoa

class DetailsViewControllerGeffe: NSViewController {
    
    @IBOutlet weak var Initial_TF: NSTextField!
    @IBOutlet weak var LFSR1_TF: NSTextField!
    @IBOutlet weak var LFSR2_TF: NSTextField!
    @IBOutlet weak var LFSR3_TF: NSTextField!
    @IBOutlet weak var Geffe_TF: NSTextField!
    @IBOutlet weak var Edited_TF: NSTextField!
    
    @IBOutlet weak var LFSR1_KEY_TF: NSTextField!
    @IBOutlet weak var LFSR2_KEY_TF: NSTextField!
    @IBOutlet weak var LFSR3_KEY_TF: NSTextField!
    
    private var CodeTFs:[String:[UInt8]] = [:]
    private var KeyTFs:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let a1:[UInt8]? = CodeTFs[LFSRDictKeys.Initial]
        let a2:[UInt8]? = CodeTFs[LFSRDictKeys.Edited]
        
        LFSR1_KEY_TF.stringValue = KeyTFs[LFSRDictKeys.KEY1] ?? ""
        LFSR2_KEY_TF.stringValue = KeyTFs[LFSRDictKeys.KEY2] ?? ""
        LFSR3_KEY_TF.stringValue = KeyTFs[LFSRDictKeys.KEY3] ?? ""
        
        var str: String = ""
        a1?.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        Initial_TF.stringValue = str
        
        str = ""
        a2?.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        Edited_TF.stringValue = str
        
        str = ""
        var a3: [UInt8] = []
        if a1 != nil && a2 != nil {
            for i in 0...a1!.count-1 {
                a3.append(a1![i]^a2![i])
            }
        }
        a3.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        Geffe_TF.stringValue = str
        
        let adjustedLength: Int = str.count
        str = ""
        a3 = CodeTFs[LFSRDictKeys.One] ?? []
        a3.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        LFSR1_TF.stringValue = str
        
        str = ""
        a3 = CodeTFs[LFSRDictKeys.Two] ?? []
        a3.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        LFSR2_TF.stringValue = str
        
        str = ""
        a3 = CodeTFs[LFSRDictKeys.Three] ?? []
        a3.forEach({ (el) in
            var appStr: String = String(el, radix: 2)
            while appStr.count < 8 {
                appStr.insert("0", at: appStr.startIndex)
            }
            appStr.append(" ")
            str.append(appStr)
        })
        LFSR3_TF.stringValue = str
        
        if LFSR1_TF.stringValue.count > adjustedLength {
            let countToRemove: Int = LFSR1_TF.stringValue.count - adjustedLength
            LFSR1_TF.stringValue.removeLast(countToRemove)
            LFSR2_TF.stringValue.removeLast(countToRemove)
            LFSR3_TF.stringValue.removeLast(countToRemove)
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "Details(Geffe)"
    }
    
    func updateTFs(_CodeTFs:[String:[UInt8]]){
        _CodeTFs.keys.forEach { (key) in
            CodeTFs.updateValue(_CodeTFs[key]!, forKey: key)
        }
    }
    
    func updateKEYS(_KeyTFs:[String:String]){
        _KeyTFs.keys.forEach { (key) in
            KeyTFs.updateValue(_KeyTFs[key]!, forKey: key)
        }
    }
    
}
