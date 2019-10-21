//
//  ViewController.swift
//  ToI_L1-2
//
//  Created by Михаил Ковалевский on 12/09/2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

// L1
// Вариант 4
// Написать программу, которая выполняет шифрование и дешифрование текстового
// файла любого размера, содержащего текст на заданном языке, используя
// следующие алгоритмы шифрования:
// - перестановочный шифр: метод «железнодорожной изгороди», текст на
// английском языке;
// - два подстановочных шифра - алгоритм Виженера, прогрессивный ключ, текст на
// русском языке. Шифр Плейфейра, текст на английском языке, шифрующую
// таблицу взять как в примере в методичке.
// Для всех алгоритмов ключ задается с клавиатуры пользователем.
// Программа должна игнорировать все символы, не являющиеся буквами заданного
// алфавита, и шифровать только текст на заданном языке. Все алгоритмы должны
// быть реализованы в одной программе. Программа не должна быть написана в
// консольном режиме. Результат работы программы –
// зашифрованный/расшифрованный файл/ы.

// L2
// V3

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    private func checkRailwayKey(key: inout String) -> Bool{
        var result: Bool = false
        key = key.lowercased().filter{digitsAlphabetString.contains($0)}
        
        if !key.isEmpty && Int(key) ?? 0 > 0 {
            result = true
        }
        
        return result
    }
    
    private func checkVigenereKey(key: inout String) -> Bool{
        var result: Bool = false
        key = key.lowercased().filter{ruAlphabetString.contains($0)}
        
        if !key.isEmpty {
            result = true
        }
        
        return result
    }
    
    private func checkPlayfairKey(key: inout String) -> Bool{
        var result: Bool = false
        key = key.lowercased().filter{enAlphabetString.contains($0)}
        
        if !key.isEmpty {
            result = true
        }
        
        return result
    }
    
    private func checkLFSRKey(key: inout String) -> Bool{
        var result: Bool = false
        key = key.lowercased().filter{binaryAlphabetString.contains($0)}
        
        if !key.isEmpty {
            result = true
        }
        
        return result
    }
    
    private func normalizedEnString(str: String) -> String{
        return str.lowercased().filter{enAlphabetString.contains($0)}
    }
    
    private func normalizedRuString(str: String) -> String{
        return str.lowercased().filter{ruAlphabetString.contains($0)}
    }
    
    private func railwayEncryption(str: String, key: Int) -> String {
        var newStr: String = ""
        let matrixLength: Int = str.count
        var mx: [[Character]] = Array(repeating: Array(repeating: " ", count: matrixLength), count: key)
        
        var iOffset: Int = 0
        var di: Int = 1
        for j in 0...matrixLength-1 {
            mx[iOffset][j] = str[str.index(str.startIndex, offsetBy: j)]
            if key>1 {
                switch iOffset {
                case 0:
                    di = 1
                case (key-1):
                    di = -1
                default:
                    break
                }
                iOffset = iOffset + di
            }
        }
        
        mx.forEach { (charArray) in
//            print(charArray)
            for i in 0...charArray.count-1 {
                if enAlphabetString.contains(charArray[i]) {
                    newStr.append(charArray[i])
                }
            }
        }
        
        return newStr
    }
    
    private func railwayDecryption(str: String, key: Int) -> String {
        var newStr: String = ""
        let matrixLength: Int = str.count
        let undefinedSymbol: Character = "?"
        var mx: [[Character]] = Array(repeating: Array(repeating: " ", count: matrixLength), count: key)
        
        var iOffset: Int = 0
        var di: Int = 1
        for j in 0...matrixLength-1 {
            mx[iOffset][j] = undefinedSymbol
            if key>1 {
                switch iOffset {
                case 0:
                    di = 1
                case (key-1):
                    di = -1
                default:
                    break
                }
                iOffset = iOffset + di
            }
        }
        
//        print()
//        mx.forEach { (charArray) in
//            print(charArray)
//        }
        
        var currentSymbol: Int = 0
        for i in 0...mx.count-1 {
            for j in 0...matrixLength-1 {
                if mx[i][j]==undefinedSymbol {
                    mx[i][j] = str[str.index(str.startIndex, offsetBy: currentSymbol)]
                    currentSymbol = currentSymbol + 1
                }
            }
        }
        
//        print()
//        mx.forEach { (charArray) in
//            print(charArray)
//        }
        
        iOffset = 0
        di = 1
        for j in 0...matrixLength-1 {
            newStr.append(mx[iOffset][j])
            if key>1 {
                switch iOffset {
                case 0:
                    di = 1
                case (key-1):
                    di = -1
                default:
                    break
                }
                iOffset = iOffset + di
            }
        }
        
        return newStr
    }
    
    private func shiftCharacter(c: Character, count: Int) -> Character? {
        let newChar: Character?
        
        if ruAlphabetString.contains(c) {
            let pos: String.Index = ruAlphabetString.firstIndex(of: c)!
            var newPos: String.Index = ruAlphabetString.index(pos, offsetBy: count)
            let endPos: String.Index = ruAlphabetString.index(ruAlphabetString.endIndex, offsetBy: -1)
            
            if newPos > endPos {
                var i: Int = 0
                i = ruAlphabetString.distance(from: endPos, to: newPos)
                newPos = ruAlphabetString.index(ruAlphabetString.startIndex, offsetBy: i-1)
            }
            
            newChar = ruAlphabetString[newPos]
        } else
            if enAlphabetString.contains(c) {
                newChar = nil
            } else {
                newChar = nil
            }
        
        return newChar
    }
    
    private func pos(c: Character ,s: String) -> Int? {
        guard let i: String.Index = s.firstIndex(of: c) else {
            return nil
        }
        
        return s.distance(from: s.startIndex, to: i)
    }
    
    private func getNextVigenereProgressiveKeyPart(k: String) -> String {
        var newKey: String = ""
        for i in 0...k.count-1 {
            newKey.append(shiftCharacter(c: k[k.index(k.startIndex, offsetBy: i)], count: 1)!)
        }
        return newKey
    }
    
    private func vigenereAlgorythm(encrypt: Bool, str: String, key: String) -> String {
        var newStr: String = ""
        var newKey: String = key
        var nextKey: String = key
        while newKey.count < str.count {
            nextKey = getNextVigenereProgressiveKeyPart(k: nextKey)
            newKey = newKey + nextKey
        }
        newKey.removeLast(newKey.count - str.count)
        
        var index: Int
        for i in 0...str.count-1 {
            let a: Int = pos(c: str[str.index(str.startIndex, offsetBy: i)], s: ruAlphabetString)!
            let b: Int = pos(c: newKey[newKey.index(newKey.startIndex, offsetBy: i)], s: ruAlphabetString)!
            if encrypt {
                index = (a+b) % ruAlphabetString.count
            } else {
//                index = a-b
//                if index < 0 {
//                    index += ruAlphabetString.count
//                }
                index = (a-b+ruAlphabetString.count) % ruAlphabetString.count
            }
            newStr.append(ruAlphabetString[ruAlphabetString.index(ruAlphabetString.startIndex, offsetBy: index)])
        }
        
//        print("M: \(str)")
//        print("K: \(newKey)")
//        print("С: \(newStr)")
        
        return newStr
    }
    
    private func vigenereEncryption(str: String, key: String) -> String {
        return vigenereAlgorythm(encrypt: true, str: str, key: key)
    }
    
    private func vigenereDecryption(str: String, key: String) -> String {
        return vigenereAlgorythm(encrypt: false, str: str, key: key)
    }
    
    private func playfairAlgorythm(encrypt: Bool, str: String, key: String) -> String {
        var newStr: String = ""
        var newKey: String = ""
        var pairs: [[Character]] = []
        
        var normalizedAlphabetStr: String = enAlphabetString.replacingOccurrences(of: "j", with: "")
        let normalizedInputStr: String = str.replacingOccurrences(of: "j", with: "i")
        let normalizedInputKey: String = key.replacingOccurrences(of: "j", with: "i")
        
        let mxSize: Int = 5
        var mx: [[Character]] = Array(repeating: Array(repeating: "?", count: mxSize), count: mxSize)
        normalizedInputKey.forEach { (c) in
            if !newKey.contains(c) {
                newKey.append(c)
                normalizedAlphabetStr.remove(at: normalizedAlphabetStr.firstIndex(of: c)!)
            }
        }
        
        newKey = newKey + normalizedAlphabetStr
        for i in 0...mxSize-1 {
            for j in 0...mxSize-1 {
                mx[i][j] = newKey[newKey.index(newKey.startIndex, offsetBy: i*mxSize + j)]
            }
        }
        
//        mx.forEach { (charArray) in
//            print(charArray)
//        }
        
        var nextPairStartIndex: String.Index = normalizedInputStr.startIndex
        let lastSymbolIndex: String.Index = normalizedInputStr.index(normalizedInputStr.endIndex, offsetBy: -1)
        while nextPairStartIndex <= lastSymbolIndex {
            var pair: [Character] = []
            var pairPos: [[Character:Int]] = []
            pair.append(normalizedInputStr[nextPairStartIndex])
            
            let nextIndex: String.Index = normalizedInputStr.index(nextPairStartIndex, offsetBy: 1)
            if nextPairStartIndex == lastSymbolIndex {
                pair.append("x")
            } else {
                pair.append(normalizedInputStr[nextIndex])
            }
            
            if pair[0] == pair[1] && encrypt {
                pair[1] = "x"
                nextPairStartIndex = nextIndex
            } else {
                if nextIndex != normalizedInputStr.endIndex {
                    nextPairStartIndex = normalizedInputStr.index(nextIndex, offsetBy: 1)
                } else {
                    nextPairStartIndex = nextIndex
                }
            }
            
            pair.forEach { (c) in
                let p: Int = pos(c: c, s: newKey)!
                var IJPos: [Character:Int] = [:]
                IJPos.updateValue(p/mxSize, forKey: "i")
                IJPos.updateValue(p%mxSize, forKey: "j")
//                IJPos.append(p/mxSize)
//                IJPos.append(p%mxSize)
                pairPos.append(IJPos)
            }
            
//            print(pair,"[",pairPos[0]["i"]!,pairPos[0]["j"]!,"] [",pairPos[1]["i"]!,pairPos[1]["j"]!,"]")
            
            let shiftValue: Int
            if encrypt {
                shiftValue = 1
            } else {
                shiftValue = mxSize - 1
            }
            
            if pairPos[0]["j"] == pairPos[1]["j"] {
                pairPos[0]["i"] = (pairPos[0]["i"]! + shiftValue) % mxSize
                pairPos[1]["i"] = (pairPos[1]["i"]! + shiftValue) % mxSize
            } else
                if pairPos[0]["i"] == pairPos[1]["i"] {
                    pairPos[0]["j"] = (pairPos[0]["j"]! + shiftValue) % mxSize
                    pairPos[1]["j"] = (pairPos[1]["j"]! + shiftValue) % mxSize
                } else {
                    let buff: Int = pairPos[0]["j"]!
                    pairPos[0]["j"] = pairPos[1]["j"]
                    pairPos[1]["j"] = buff
                }
            
            pair[0] = mx[pairPos[0]["i"]!][pairPos[0]["j"]!]
            pair[1] = mx[pairPos[1]["i"]!][pairPos[1]["j"]!]
            
//            newStr.append(pair[0])
//            newStr.append(pair[1])
            pairs.append(pair)
        }
        
        if encrypt {
            pairs.forEach { (pair) in
                newStr.append(pair[0])
                newStr.append(pair[1])
            }
        } else {
            for i in 0...pairs.count-2 {
                if pairs[i][0] == pairs[i+1][0] && pairs[i][1] == "x" {
                    newStr.append(pairs[i][0])
                } else {
                    newStr.append(pairs[i][0])
                    newStr.append(pairs[i][1])
                }
            }
            newStr.append(pairs[pairs.count-1][0])
            newStr.append(pairs[pairs.count-1][1])
        }
        
        return newStr
    }
    
    private func playfairEncryption(str: String, key: String) -> String {
        return playfairAlgorythm(encrypt: true, str: str, key: key)
    }
    
    private func playfairDecryption(str: String, key: String) -> String {
        return playfairAlgorythm(encrypt: false, str: str, key: key)
    }
    
    private func LFSRNormalizeKey(key: inout String, pwr: Int){
        key = key.padding(toLength: pwr, withPad: "0", startingAt: 0)
    }
    
    private func LFSRGetXorV(regCondition: inout UInt64, bitsToXor: [Int], pPow: Int) -> UInt8 {
        var xor: UInt64
        for _ in 0...7 {
            xor = 0
            bitsToXor.forEach { (bitPos) in
                xor = xor^((regCondition >> bitPos) & 1)
            }
            regCondition = regCondition << 1
            regCondition = regCondition + xor
        }
//        print(String(UInt8((regCondition >> pPow) & 0b11111111), radix: 2))
        return UInt8((regCondition >> pPow) & 0b11111111)
    }
    
    private func LFSRAlgorithm(fileURL: URL, encryption: Bool, saveToFile: Bool, _key: String, pPow: Int, bitsToXor: [Int]) {
        let newKey: String = _key.padding(toLength: pPow, withPad: "0", startingAt: 0)
        var regCondition: UInt64 = UInt64(newKey, radix: 2)!
//        var xorV: UInt8 = 0
        var keyDict: [String:String] = [:]
        keyDict.updateValue(newKey, forKey: LFSRDictKeys.KEY1)
        detailsLFSR.updateKEYS(_KeyTFs: keyDict)
        
        if let data: NSData = NSData(contentsOf: fileURL) {
            let affix: String
            if encryption {
                affix = "_enc(L)"
            } else {
                affix = "_dec(L)"
            }
            let url: URL = lastDirectoryURL!.appendingPathComponent(lastFileName!+affix).appendingPathExtension(fileURL.pathExtension)
            activeResultFileURL = url
            
            var bytesLeft:Int = data.length
            var locationToReadFrom:Int = 0
            var currentBlockSize: Int = 0
            
            let dataToAppend: NSMutableData = NSMutableData()
            
            if bytesLeft<blockSizeByteValue {
                currentBlockSize = bytesLeft
                bytesLeft = 0
            } else {
                currentBlockSize = blockSizeByteValue
                bytesLeft = bytesLeft - blockSizeByteValue
            }
            while currentBlockSize > 0 {
                var buffer:[UInt8] = Array(repeating: 0, count: currentBlockSize)
                data.getBytes(&buffer, range: NSRange(location: locationToReadFrom, length: currentBlockSize))
                
                for i in 0...(currentBlockSize-1) {
                    buffer[i] = buffer[i]^LFSRGetXorV(regCondition: &regCondition, bitsToXor: bitsToXor, pPow: pPow)
                }
                
                dataToAppend.append(Data(buffer))
                
                if bytesLeft<blockSizeByteValue{
                    locationToReadFrom = locationToReadFrom + currentBlockSize
                    currentBlockSize = bytesLeft
                    bytesLeft = 0
                } else {
                    locationToReadFrom = locationToReadFrom + currentBlockSize
                    currentBlockSize = blockSizeByteValue
                    bytesLeft = bytesLeft - blockSizeByteValue
                }
            }
            
            do {
                try dataToAppend.write(to: url, options: .atomic)
            } catch _ {
                
            }
        } else {
            print("-> Error getting data form \(fileURL)")
        }
    }
    
    private func simulateLFSRKeyGenerator(_regCondition:UInt64,_pPow:Int,_bitsToXor:[Int],_simCount:Int) -> [UInt8] {
        var simulatedXorKey: [UInt8] = Array(repeating: 0, count: _simCount)
        var regCondition: UInt64 = _regCondition
        for i in 0..._simCount-1 {
            simulatedXorKey[i] = LFSRGetXorV(regCondition: &regCondition, bitsToXor: _bitsToXor, pPow: _pPow)
        }
        return simulatedXorKey
    }
    
    private func GeffeAlgorithm(fileURL: URL, encryption: Bool, saveToFile: Bool, _keys: [String], pPows: [Int], bitsToXor: [[Int]]) {
        var newKeys: [String] = Array(repeating: "", count: _keys.count)
        var regConditions: [UInt64] = Array(repeating: 0, count: newKeys.count)
        for i in 0...2 {
            newKeys[i] = _keys[i].padding(toLength: pPows[i], withPad: "0", startingAt: 0)
            regConditions[i] = UInt64(newKeys[i], radix: 2)!
        }
        detailsGeffe.updateKEYS(_KeyTFs: [LFSRDictKeys.KEY1 : newKeys[0]])
        detailsGeffe.updateKEYS(_KeyTFs: [LFSRDictKeys.KEY2 : newKeys[1]])
        detailsGeffe.updateKEYS(_KeyTFs: [LFSRDictKeys.KEY3 : newKeys[2]])
        detailsGeffe.updateTFs(_CodeTFs: [LFSRDictKeys.One : simulateLFSRKeyGenerator(_regCondition: regConditions[0], _pPow: pPows[0], _bitsToXor: bitsToXor[0], _simCount: outputByteCount)])
        detailsGeffe.updateTFs(_CodeTFs: [LFSRDictKeys.Two : simulateLFSRKeyGenerator(_regCondition: regConditions[1], _pPow: pPows[1], _bitsToXor: bitsToXor[1], _simCount: outputByteCount)])
        detailsGeffe.updateTFs(_CodeTFs: [LFSRDictKeys.Three : simulateLFSRKeyGenerator(_regCondition: regConditions[2], _pPow: pPows[2], _bitsToXor: bitsToXor[2], _simCount: outputByteCount)])
        if let data: NSData = NSData(contentsOf: fileURL) {
            let affix: String
            if encryption {
                affix = "_enc(G)"
            } else {
                affix = "_dec(G)"
            }
            let url: URL = lastDirectoryURL!.appendingPathComponent(lastFileName!+affix).appendingPathExtension(fileURL.pathExtension)
            activeResultFileURL = url
            
            var bytesLeft:Int = data.length
            var locationToReadFrom:Int = 0
            var currentBlockSize: Int = 0
            let dataToAppend: NSMutableData = NSMutableData()
            
            if bytesLeft<blockSizeByteValue {
                currentBlockSize = bytesLeft
                bytesLeft = 0
            } else {
                currentBlockSize = blockSizeByteValue
                bytesLeft = bytesLeft - blockSizeByteValue
            }
            
            while currentBlockSize > 0 {
                var buffer:[UInt8] = Array(repeating: 0, count: currentBlockSize)
                
                data.getBytes(&buffer, range: NSRange(location: locationToReadFrom, length: currentBlockSize))
                for i in 0...(currentBlockSize-1) {
                    let xorV1: UInt8 = LFSRGetXorV(regCondition: &regConditions[0], bitsToXor: bitsToXor[0], pPow: pPows[0])
                    let xorV2: UInt8 = LFSRGetXorV(regCondition: &regConditions[1], bitsToXor: bitsToXor[1], pPow: pPows[1])
                    let xorV3: UInt8 = LFSRGetXorV(regCondition: &regConditions[2], bitsToXor: bitsToXor[2], pPow: pPows[2])
                    buffer[i] = buffer[i]^((xorV1 & xorV2) | (~xorV1 & xorV3))
                }
                
                dataToAppend.append(Data(buffer))
                
                if bytesLeft<blockSizeByteValue{
                    locationToReadFrom = locationToReadFrom + currentBlockSize
                    currentBlockSize = bytesLeft
                    bytesLeft = 0
                } else {
                    locationToReadFrom = locationToReadFrom + currentBlockSize
                    currentBlockSize = blockSizeByteValue
                    bytesLeft = bytesLeft - blockSizeByteValue
                }
            }
                          
            do {
                try dataToAppend.write(to: url, options: .atomic)
            } catch _ {
            
            }
        } else {
            print("-> Error getting data form \(fileURL)")
        }
        
    }

    
    private let binaryAlphabetString: String = "01"
    private let digitsAlphabetString: String = "0123456789"
    private let ruAlphabetString: String = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    private let enAlphabetString: String = "abcdefghijklmnopqrstuvwxyz"
    private let encTypes: [String] = ["Railway(en)", "Vigenère(ru)", "Playfair(en)", "LFSR(^25)", "Geffe(^25,^33,^23)"] // APPEND BUT DO NOT CHANGE ORDER
    
    private let LFSR1_PolynomialPwr: Int = 25
    private let LFSR1_BitsToXor: [Int] = [3-1,25-1]
    private let LFSR2_PolynomialPwr: Int = 33
    private let LFSR2_BitsToXor: [Int] = [13-1,33-1]
    private let LFSR3_PolynomialPwr: Int = 23
    private let LFSR3_BitsToXor: [Int] = [23-1,5-1]
    
    private var activeFileURL: URL? = nil
    private var activeResultFileURL: URL? = nil
    private var lastDirectoryURL: URL? = nil
    private var lastFileName: String? = nil
    private var buffString: String? = nil
    
    private var blockNonStreamEncDec: Bool = false
    private let previewSymbolCount: Int = 200
    private let fileIsTooBigByteValue: Int = 1048576 // 1MB
    private let blockSizeByteValue: Int = 65536 // 64KB
    private let outputByteCount: Int = 50
    
    private var resultTFStdYOffsetConstraintConstant: CGFloat? = nil
    private var resultTFGeffeYOffsetConstraintConstant: CGFloat? = nil
    private let resultTFYOffsetConstraintIdentifier: String? = "ResultYOffsetConstraint"
    private var resultTFYOffsetConstraint: NSLayoutConstraint? = nil
    
    private var detailsLFSR: DetailsViewControllerLFSR!
    private var detailsGeffe: DetailsViewControllerGeffe!
    
    @IBOutlet weak var encryptButton: NSButton!
    @IBOutlet weak var decryptButton: NSButton!
    @IBOutlet weak var detailsButton: NSButton!
    
    @IBOutlet weak var encTypesPopUpButton: NSPopUpButton!
    @IBOutlet weak var saveToFileCheckBox: NSButton!
    
    @IBOutlet weak var fileLabel: NSTextField!
    
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var resultTextField: NSTextField!
    
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var LFSR2_KeyTextField: NSTextField!
    @IBOutlet weak var LFSR3_KeyTextField: NSTextField!
    private var keyTextFields: [NSTextField]! = [] // Fill with every key field in viewDidLoad
    
    
    @IBAction func openDocument(_ sender: Any) {
        print("Opening document")
        let dialog: NSOpenPanel = NSOpenPanel()
        dialog.title = "Choose file to encrypt"
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK {
            detailsLFSR = DetailsViewControllerLFSR()
            detailsGeffe = DetailsViewControllerGeffe()
            
            if dialog.url != nil {
                let ext = dialog.url?.pathExtension
                lastDirectoryURL = dialog.directoryURL
                lastFileName = dialog.url?.deletingPathExtension().lastPathComponent
                activeFileURL = dialog.url!
                var err: String? = nil
                var byteCount:Int? = nil
                if let data: NSData = NSData(contentsOf: dialog.url!) {
                    byteCount = data.length
                }
                
                buffString = nil
                do {
                    if (byteCount != nil) && byteCount! > fileIsTooBigByteValue {
                        err = "File is too big"
                        throw NSError(domain: "File was defined as too big by the app", code: 13201, userInfo: [:])
                    }
                    
                    buffString = try String(contentsOf: dialog.url!)
                    
                    var previewStr: String = buffString!
                    if (previewStr.count - previewSymbolCount) > 0 {
                        previewStr.removeLast(previewStr.count - previewSymbolCount)
                        previewStr = previewStr + "..."
                    }
                    inputTextField.stringValue = previewStr
                    blockNonStreamEncDec = false
                    inputTextField.isEnabled = true
                    resultTextField.isEnabled = true
                    
                } catch _ {
                    if err == nil {
                        err = "Invalid encoding"
                    }
                    inputTextField.stringValue = "> Unable to create preview(\(err!))!\n> Available algorithms: \(encTypes[3]), \(encTypes[4])"
                    blockNonStreamEncDec = true
                    inputTextField.isEnabled = false
                    resultTextField.isEnabled = false
                }
                
                fileLabel.stringValue = "File: " + lastFileName! + "." + ext!
                if byteCount != nil {
                    fileLabel.stringValue = fileLabel.stringValue + " (bytes: " + String(byteCount!) + ")"
                }
                encTypesPopUpButton.isEnabled = true
                
                encTypesPopUpButtonSelectionDidChange(encTypesPopUpButton)
            } else {
                print("Error opening file")
            }
        }
        
    }
    
    @IBAction func encryptAction(_ sender: Any){
        let encType: String = encTypesPopUpButton.title
        var alreadySavedFile: Bool = false
        var key: String = keyTextField.stringValue
        print()
        print("Initiating encryption!")
        print("Encryption type: \(encType)")
        print("Key: \(key)")
        
        let result: String
        switch encType {
        case encTypes[0]:
            if checkRailwayKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedEnString(str: str)
                if !str.isEmpty {
                    result = railwayEncryption(str: str, key: Int(key)!)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[1]:
            if checkVigenereKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedRuString(str: str)
                if !str.isEmpty {
                    result = vigenereEncryption(str: str, key: key)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[2]:
            if checkPlayfairKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedEnString(str: str)
                if !str.isEmpty {
                    result = playfairEncryption(str: str, key: key)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[3]:
            if checkLFSRKey(key: &key){
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                LFSRAlgorithm(fileURL: activeFileURL!, encryption: true, saveToFile: true, _key: key, pPow: LFSR1_PolynomialPwr, bitsToXor: LFSR1_BitsToXor)
                alreadySavedFile = true
                
                if buffString == nil {
                    result = resultTextField.stringValue
                } else {
                    result = "> LFSREncryption PREVIEW"
                }
                
                detailsButton.isEnabled = true
            } else {
                alreadySavedFile = true
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[4]:
            var keys: [String] = [key]
            keys.append(LFSR2_KeyTextField.stringValue)
            keys.append(LFSR3_KeyTextField.stringValue)
            var flag: Bool = true
            for i in 0...2 {
                if !checkLFSRKey(key: &keys[i]) {
                    keyTextFields[i].textColor = .systemPink
                    flag = false
                } else {
                    keyTextFields[i].stringValue = keys[i]
                    keyTextFields[i].textColor = .green
                }
            }
            
            if flag {
                GeffeAlgorithm(fileURL: activeFileURL!, encryption: true, saveToFile: true, _keys: keys, pPows: [LFSR1_PolynomialPwr,LFSR2_PolynomialPwr,LFSR3_PolynomialPwr,], bitsToXor: [LFSR1_BitsToXor,LFSR2_BitsToXor,LFSR3_BitsToXor])
                alreadySavedFile = true
                if buffString == nil {
                    result = resultTextField.stringValue
                } else {
                    result = "> LFSREncryption PREVIEW"
                }
                detailsButton.isEnabled = true
            } else {
                alreadySavedFile = true
                result = ""
            }
        default:
            result = "> Invalid encryption type!"
            alreadySavedFile = true
        }
        
        var previewStr: String = result
        if (previewStr.count - previewSymbolCount) > 0 {
            previewStr.removeLast(previewStr.count - previewSymbolCount)
            previewStr = previewStr + "..."
        }
        resultTextField.stringValue = previewStr
        
        if !alreadySavedFile && saveToFileCheckBox.state == .on {
            let affix: String = "_enc(" + String(encType[encType.index(encType.startIndex, offsetBy: 0)]) + ")"
            let url: URL = lastDirectoryURL!.appendingPathComponent(lastFileName!+affix).appendingPathExtension("txt")
            
            do {
                try result.write(to: url, atomically: true, encoding: .utf8)
            } catch let err {
               print(err)
            }
        }
        
        print("Finished encryption!")
    }
    
    @IBAction func decryptAction(_ sender: Any){
        let encType: String = encTypesPopUpButton.title
        var key: String = keyTextField.stringValue
        var alreadySavedFile: Bool = false
        
        print()
        print("Initiating decryption!")
        print("Decryption type: \(encType)")
        print("Key: \(key)")
        
        let result: String
        switch encType {
        case encTypes[0]:
            if checkRailwayKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedEnString(str: str)
                if !str.isEmpty {
                    result = railwayDecryption(str: str, key: Int(key)!)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[1]:
            if checkVigenereKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedRuString(str: str)
                if !str.isEmpty {
                    result = vigenereDecryption(str: str, key: key)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[2]:
            if checkPlayfairKey(key: &key){
                var str: String = buffString!
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                str = normalizedEnString(str: str)
                if !str.isEmpty {
                    result = playfairDecryption(str: str, key: key)
                } else {
                    result = ""
                }
            } else {
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[3]:
            if checkLFSRKey(key: &key){
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                
                LFSRAlgorithm(fileURL: activeFileURL!, encryption: false, saveToFile: true, _key: key, pPow: LFSR1_PolynomialPwr, bitsToXor: LFSR1_BitsToXor)
                alreadySavedFile = true
                
                if buffString == nil {
                    result = resultTextField.stringValue
                } else {
                    result = "> LFSRDecryption PREVIEW"
                }
                
                detailsButton.isEnabled = true
            } else {
                alreadySavedFile = true
                keyTextField.textColor = .systemPink
                result = ""
            }
        case encTypes[4]:
            var keys: [String] = [key]
            keys.append(LFSR2_KeyTextField.stringValue)
            keys.append(LFSR3_KeyTextField.stringValue)
            var flag: Bool = true
            for i in 0...2 {
                if !checkLFSRKey(key: &keys[i]) {
                    keyTextFields[i].textColor = .systemPink
                    flag = false
                } else {
                    keyTextFields[i].stringValue = keys[i]
                    keyTextFields[i].textColor = .green
                }
            }
            
            if flag {
                GeffeAlgorithm(fileURL: activeFileURL!, encryption: false, saveToFile: true, _keys: keys, pPows: [LFSR1_PolynomialPwr,LFSR2_PolynomialPwr,LFSR3_PolynomialPwr,], bitsToXor: [LFSR1_BitsToXor,LFSR2_BitsToXor,LFSR3_BitsToXor])
                alreadySavedFile = true
                if buffString == nil {
                    result = resultTextField.stringValue
                } else {
                    result = "> LFSREncryption PREVIEW"
                }
                detailsButton.isEnabled = true
            } else {
                alreadySavedFile = true
                result = ""
            }
        default:
            result = "> Invalid decryption type!"
            alreadySavedFile = true
        }
        
        var previewStr: String = result
        if (previewStr.count - previewSymbolCount) > 0 {
            previewStr.removeLast(previewStr.count - previewSymbolCount)
            previewStr = previewStr + "..."
        }
        resultTextField.stringValue = previewStr
        
        if !alreadySavedFile && saveToFileCheckBox.state == .on {
            let url: URL = lastDirectoryURL!.appendingPathComponent(lastFileName!+"_dcr").appendingPathExtension("txt")
            
            do {
                try result.write(to: url, atomically: true, encoding: .utf8)
            } catch let err {
                print(err)
            }
        }
        
        print("Finished decryption!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyTextField.delegate = self
        LFSR2_KeyTextField.delegate = self
        LFSR3_KeyTextField.delegate = self
        inputTextField.delegate = self
        resultTextField.delegate = self
        
        for constraint in self.view.constraints {
            if constraint.identifier == resultTFYOffsetConstraintIdentifier {
                resultTFYOffsetConstraint = constraint
            }
        }
        if resultTFYOffsetConstraint != nil {
            resultTFStdYOffsetConstraintConstant = resultTFYOffsetConstraint!.constant
            resultTFGeffeYOffsetConstraintConstant = resultTFStdYOffsetConstraintConstant!*4.4
        } else {
            fatalError("-> Unable to find \"resultTFYOffsetConstraint\"")
        }
        
        keyTextFields.append(keyTextField)
        keyTextFields.append(LFSR2_KeyTextField)
        keyTextFields.append(LFSR3_KeyTextField)
        
        prepareUI()
        
//        debugDetailsLFSR()
//        debugDetailsGeffe()
    }
    
    private func debugDetailsGeffe(){
        self.presentAsModalWindow(detailsGeffe)
    }
    
    private func debugDetailsLFSR(){
        self.presentAsModalWindow(detailsLFSR)
    }
    
    private func prepareUI(){
        inputTextField.isEnabled = false
        keyTextField.isEnabled = false
        resultTextField.isEnabled = false
        
        encTypesPopUpButton.removeAllItems()
        encTypesPopUpButton.addItems(withTitles: encTypes)
        
        encTypesPopUpButton.selectItem(at: 3)
        
        encTypesPopUpButtonSelectionDidChange(encTypesPopUpButton)
        
        for tf in keyTextFields {
            tf.isEnabled = false
        }
        encTypesPopUpButton.isEnabled = false
        saveToFileCheckBox.isEnabled = false
    }
    
    private func resetUI(zeroKey: String?, extraActionsListNumber: Int?){
        // Actions:
        //      nil - std   3 - LFSR  4 - Geffe
        keyTextField.stringValue = zeroKey ?? ""
        keyTextField.textColor = .white
        
        switch extraActionsListNumber {
        case 4:
            LFSR2_KeyTextField.stringValue = ""
            LFSR3_KeyTextField.stringValue = ""
            LFSR2_KeyTextField.textColor = .white
            LFSR3_KeyTextField.textColor = .white
            LFSR2_KeyTextField.isHidden = false
            LFSR3_KeyTextField.isHidden = false
            resultTFYOffsetConstraint!.constant = resultTFGeffeYOffsetConstraintConstant!
        default:
            LFSR2_KeyTextField.isHidden = true
            LFSR3_KeyTextField.isHidden = true
            resultTFYOffsetConstraint!.constant = resultTFStdYOffsetConstraintConstant!
        }
        self.view.layout()
    }
    
    @IBAction func encTypesPopUpButtonSelectionDidChange(_ sender: NSPopUpButton) {
//        inputTextField.stringValue = ""
        switch encTypesPopUpButton.indexOfSelectedItem {
        case 4:
            // Geffe
            resetUI(zeroKey: nil, extraActionsListNumber: 4)
            toggleDetails(to: true)
            toggleEncDec()
            keyTextField.isEnabled = true
            keyTextField.placeholderString = "LFSR_KEY1 ^25"
            LFSR2_KeyTextField.isEnabled = true
            LFSR3_KeyTextField.isEnabled = true
            saveToFileCheckBox.state = .on
            saveToFileCheckBox.isEnabled = false
        case 3:
            // LFSR
            resetUI(zeroKey: nil, extraActionsListNumber: nil)
            toggleDetails(to: true)
            toggleEncDec()
            keyTextField.isEnabled = true
            keyTextField.placeholderString = "LFSR_KEY1 ^25"
            saveToFileCheckBox.state = .on
            saveToFileCheckBox.isEnabled = false
        default:
            resetUI(zeroKey: nil, extraActionsListNumber: nil)
            toggleDetails(to: false)
            toggleEncDec()
            if blockNonStreamEncDec {
                keyTextField.isEnabled = false
            } else {
                keyTextField.isEnabled = true
            }
            keyTextField.placeholderString = "Key"
            saveToFileCheckBox.state = .off
            saveToFileCheckBox.isEnabled = true
        }
        
        if !blockNonStreamEncDec {
            resultTextField.stringValue = ""
        } else {
            resultTextField.stringValue = "> Result preview is unavailable!"
        }
    }
    
    private func toggleDetails(to: Bool){
        detailsButton.isHidden = !to
        detailsButton.isEnabled = false
    }
    
    private func toggleEncDec(){
        var enableEncDec: Bool = true
        keyTextFields.forEach { (tf) in
            if !tf.isHidden {
                if tf.stringValue.isEmpty {
                    enableEncDec = false
                }
            }
        }
        encryptButton.isEnabled = enableEncDec
        decryptButton.isEnabled = enableEncDec
    }
    
    func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as? NSTextField
        if textField?.identifier != nil {
            switch textField?.identifier {
            case keyTextField.identifier:
                if (encTypesPopUpButton.indexOfSelectedItem == 3 || encTypesPopUpButton.indexOfSelectedItem == 4) && keyTextField.stringValue.count > LFSR1_PolynomialPwr {
                    keyTextField.stringValue.removeLast()
                }
                keyTextField.textColor = .white
                toggleEncDec()
            case LFSR2_KeyTextField.identifier:
                if encTypesPopUpButton.indexOfSelectedItem == 4 && LFSR2_KeyTextField.stringValue.count > LFSR2_PolynomialPwr {
                    LFSR2_KeyTextField.stringValue.removeLast()
                }
                LFSR2_KeyTextField.textColor = .white
                toggleEncDec()
            case LFSR3_KeyTextField.identifier:
                if encTypesPopUpButton.indexOfSelectedItem == 4 && LFSR3_KeyTextField.stringValue.count > LFSR3_PolynomialPwr {
                    LFSR3_KeyTextField.stringValue.removeLast()
                }
                LFSR3_KeyTextField.textColor = .white
                toggleEncDec()
            case inputTextField.identifier:
                inputTextField.abortEditing()
            case resultTextField.identifier:
                resultTextField.abortEditing()
            default:
                break
            }
        }
    }
    
    @IBAction func detailsAction(_ sender: Any){
        var data: NSData? = NSData(contentsOf: activeFileURL!)
        var codeDict: [String:[UInt8]] = [:]
        var count: Int = outputByteCount
        
        if data != nil {
            if data!.count < count {
                count = data!.count
            }
            var buffer: [UInt8] = Array(repeating: 0, count: count)
            data?.getBytes(&buffer, length: buffer.count)
            codeDict.updateValue(buffer, forKey: LFSRDictKeys.Initial)
        }
        data = NSData(contentsOf: activeResultFileURL!)
        if data != nil {
            var buffer: [UInt8] = Array(repeating: 0, count: count)
            data?.getBytes(&buffer, length: buffer.count)
            codeDict.updateValue(buffer, forKey: LFSRDictKeys.Edited)
        }
        
        switch encTypesPopUpButton.indexOfSelectedItem {
        case 3:
            detailsLFSR.updateTFs(_CodeTFs: codeDict)
            self.presentAsModalWindow(detailsLFSR)
        case 4:
            detailsGeffe.updateTFs(_CodeTFs: codeDict)
            self.presentAsModalWindow(detailsGeffe)
        default:
            break
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

