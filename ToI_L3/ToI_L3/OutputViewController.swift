//
//  OutputViewController.swift
//  ToI_L3
//
//  Created by Михаил Ковалевский on 11.11.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Cocoa

class OutputViewController: NSViewController {
    
    private let byteCount: Int = 50
    
    private var style: Int = 0
    
    private var FILE_URL: URL!
    private var FirstStyleStr: String? = nil
    private var SecondStyleStr: String? = nil
    
    @IBOutlet weak var styleLabel: NSTextField!
    @IBOutlet weak var mainTF: NSTextField!
    @IBOutlet weak var switchStyleButton: NSButton!
    
    @IBAction func switchStringStyle(_ sender: NSButton) {
        switch sender.identifier {
        case switchStyleButton.identifier:
            print("Switch style button tapped")
            if style == 1 {
                style = 2
                mainTF.stringValue = SecondStyleStr ?? ">ERROR HANDLING SecondStyleStr == nil"
                styleLabel.stringValue = "AB STYLE"
            } else {
                style = 1
                mainTF.stringValue = FirstStyleStr ?? ">ERROR HANDLING FirstStyleStr == nil"
                styleLabel.stringValue = "STD STYLE"
            }
        default:
            print("> Invalid Button in func switchStringStyle()!")
            print("> NSButton:    \(sender)")
            if sender.identifier != nil {
                print("> Identifier:  \(String(describing: sender.identifier!))")
            } else {
                print("> Identifier:  nil")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        mainTF.stringValue = FirstStyleStr ?? ">ERROR READING DATA FROM FILE"
        style = 1
        
        if SecondStyleStr == nil {
            switchStyleButton.isEnabled = false
        }
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "FILE: " + FILE_URL.lastPathComponent
    }
    
    func updateFileURL(_url: URL){
        FILE_URL = _url
    }
    
    func createStrings(){
        if let data: NSData = NSData(contentsOf: FILE_URL) {
            if data.length > 0 {
                let extendedByteCount: Int = byteCount*16
                let currentBlockSize: Int
                if data.length<extendedByteCount {
                    currentBlockSize = data.length
                } else {
                    currentBlockSize = extendedByteCount
                }
                
                var buffer:[UInt8] = Array(repeating: 0, count: currentBlockSize)
                data.getBytes(&buffer, length: currentBlockSize)
                
                FirstStyleStr = ""
                buffer.forEach { (element) in
                    FirstStyleStr!.append(String(format: "%03d ", element))
                }
                
                if currentBlockSize % 16 == 0 {
                    SecondStyleStr = ""
                    let ABBlockCount: Int = currentBlockSize/16
                    var buffArr: [String] = []
                    for i in 0...ABBlockCount-1 {
                        let pos: Int = i*16
                        let ABytes: [UInt8] = Array(buffer[pos...pos+7])
                        let BBytes: [UInt8] = Array(buffer[pos+8...pos+15])
                        let A: UInt64 = Arr8toUI64(arr: ABytes)!
                        let B: UInt64 = Arr8toUI64(arr: BBytes)!
                        buffArr.append(String(format: "(a:%u,b:%u)", A, B))
                    }
                    
                    var maxLength: Int = 0
                    buffArr.forEach { (str) in
                        if str.count > maxLength {
                            maxLength = str.count
                        }
                    }
                    
                    buffArr.forEach { (str) in
                        SecondStyleStr!.append(str.padding(toLength: maxLength, withPad: "\u{00a0}", startingAt: 0))
                        SecondStyleStr!.append("-")
                    }
                }
            } else {
                FirstStyleStr = ""
                SecondStyleStr = ""
            }
        }
    }
    
}
