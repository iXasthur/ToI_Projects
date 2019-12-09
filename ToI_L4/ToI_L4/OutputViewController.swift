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
    
    
    private var FILE_URL: URL!
    private var FirstStyleStr: String? = nil
    
    @IBOutlet weak var styleLabel: NSTextField!
    @IBOutlet weak var mainTF: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        mainTF.stringValue = FirstStyleStr ?? ">ERROR READING DATA FROM FILE"
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
                
            } else {
                FirstStyleStr = ""
            }
        }
    }
    
}
