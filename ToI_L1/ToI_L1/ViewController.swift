//
//  ViewController.swift
//  ToI_L1
//
//  Created by Михаил Ковалевский on 12/09/2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

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
            print(charArray)
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
        
        print()
        mx.forEach { (charArray) in
            print(charArray)
        }
        
        var currentSymbol: Int = 0
        for i in 0...mx.count-1 {
            for j in 0...matrixLength-1 {
                if mx[i][j]==undefinedSymbol {
                    mx[i][j] = str[str.index(str.startIndex, offsetBy: currentSymbol)]
                    currentSymbol = currentSymbol + 1
                }
            }
        }
        
        print()
        mx.forEach { (charArray) in
            print(charArray)
        }
        
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
        
        print("M: \(str)")
        print("K: \(newKey)")
        print("С: \(newStr)")
        
        return newStr
    }
    
    private func vigenereEncryption(str: String, key: String) -> String {
        return vigenereAlgorythm(encrypt: true, str: str, key: key)
    }
    
    private func vigenereDecryption(str: String, key: String) -> String {
        return vigenereAlgorythm(encrypt: false, str: str, key: key)
    }
    
    private func playfairEncryption(str: String, key: String) -> String {
        var newStr: String = str
        
        return newStr
    }
    
    private func playfairDecryption(str: String, key: String) -> String {
        var newStr: String = str
        
        return newStr
    }
    
    
//    private let digitsAlphabet: CharacterSet = CharacterSet.init(charactersIn: "0"..."9")
//    private let ruAlphabet: CharacterSet = CharacterSet.init(charactersIn: "а"..."я")
//    private let engAlphabet: CharacterSet = CharacterSet.init(charactersIn: "a"..."z")
    private let digitsAlphabetString: String = "0123456789"
    private let ruAlphabetString: String = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    private let enAlphabetString: String = "abcdefghijklmnopqrstuvwxyz"
    private let encTypes: [String] = ["Railway(en)", "Vigenère(ru)", "Playfair(en)"]
    
    @IBOutlet weak var encTypesPopUpButton: NSPopUpButton!
    @IBOutlet weak var saveToFileCheckBox: NSButton!
    
    @IBOutlet weak var fileLabel: NSTextField!
    
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var resultTextField: NSTextField!
    
    @IBAction func encryptAction(_ sender: Any){
        var str: String = inputTextField.stringValue
        let encType: String = encTypesPopUpButton.title
        var key: String = keyTextField.stringValue
        print("Encrypting msg: \(str)")
        print("Encryption type: \(encType)")
        print("Key: \(key)")
        
        let result: String
        switch encType {
        case encTypes[0]:
            if checkRailwayKey(key: &key){
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                str = normalizedEnString(str: str)
                inputTextField.stringValue = str
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
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                str = normalizedRuString(str: str)
                inputTextField.stringValue = str
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
            result = playfairEncryption(str: str, key: key)
        default:
            result = "> Invalid encryption type!"
        }
        
        resultTextField.stringValue = result
    }
    
    @IBAction func decryptAction(_ sender: Any){
        var str: String = inputTextField.stringValue
        let encType: String = encTypesPopUpButton.title
        var key: String = keyTextField.stringValue
        print("Decrypting msg: \(str)")
        print("Decryption type: \(encType)")
        print("Key: \(key)")
        
        let result: String
        switch encType {
        case encTypes[0]:
            if checkRailwayKey(key: &key){
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                str = normalizedEnString(str: str)
                inputTextField.stringValue = str
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
                keyTextField.stringValue = key
                keyTextField.textColor = .green
                str = normalizedRuString(str: str)
                inputTextField.stringValue = str
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
            result = playfairDecryption(str: str, key: key)
        default:
            result = "> Invalid encryption type!"
        }
        
        resultTextField.stringValue = result
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyTextField.delegate = self
        resultTextField.delegate = self
        
        prepareUI()
    }
    
    private func prepareUI(){
        encTypesPopUpButton.removeAllItems()
        encTypesPopUpButton.addItems(withTitles: encTypes)
        
        encTypesPopUpButton.selectItem(at: 1)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as? NSTextField
        if textField?.identifier != nil {
            switch textField?.identifier {
            case keyTextField.identifier:
                keyTextField.textColor = .white
            case resultTextField.identifier:
                resultTextField.abortEditing()
            default:
                break
            }
        }
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

