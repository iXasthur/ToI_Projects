//
//  ElGamalSystem.swift
//  ToI_L3
//
//  Created by Михаил Ковалевский on 09.11.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Foundation

func fast_mod64(value: UInt64, power: UInt64, mod: UInt64) -> UInt64 {
    var v: UInt64 = value;
    var p: UInt64 = power;
    var x: UInt64 = 1;
    
    while p != 0 {
        while (p % 2) == 0 {
            p = p/2
            v = v*v % mod
        }
        p = p - 1
        x = (x*v) % mod
    }
    
    return x
}

func euler64(of v: UInt64) -> UInt64 {
    var result: UInt64 = v
    var n: UInt64 = v
    
    var i: UInt64 = 2
    while i<=n {
        if (n % i == 0) {
            while (n % i == 0) {
                n = n/i;
            }
            result = result - result / i
        }
        i = i + 1
    }
    
    if (n > 1) {
        result = result - result/n
    }
    return result;
}

func isPrimitiveDivider(v: UInt64, of n: UInt64) -> Bool {
    var ret: Bool = false
    if (n%v==0) && (euler64(of: v) == v-1) {
        ret = true
    }
    return ret
}

func getPrimitiveRoots(of v: UInt64) -> [UInt64]{
    var buffArr: [UInt64] = []
    if v>2 {
        var primitiveDividers: [UInt64] = []
        for i: UInt64 in 2...(v-1)/2+1{
            if (isPrimitiveDivider(v: i, of: v-1)) {
                primitiveDividers.append(i)
            }
        }
        
        if primitiveDividers.count > 0 && euler64(of: v) == v-1 {
            for g in 2...(v-1) {
                var err: Bool = false
                primitiveDividers.forEach { (divider) in
                    if (fast_mod64(value: g, power: (v-1)/divider, mod: v) == 1) {
                        err = true
                    }
                }
                if !err {
                    buffArr.append(g)
                }
            }
        }
    } else
        if v == 2 {
            buffArr = [1]
        }
    return buffArr
}

func UI64toArr8(v: UInt64) -> [UInt8]{
    var ret: [UInt8] = Array(repeating: 0, count: 8)
    let _v: UInt64 = v.bigEndian
    let byte64: UInt64 = 255
    for i in (0...7) {
        ret[i] = UInt8((_v >> (i*8))&byte64)
    }
    return ret
}

func Arr8toUI64(arr: [UInt8]) -> UInt64? {
    var ret: UInt64? = nil
    if arr.count == 8 {
        ret = 0
        let data = NSData(bytes: arr, length: 8)
        data.getBytes(&ret, length: 8)
        ret = UInt64(bigEndian: ret!)
    }
    return ret
}

func ElGamalEncryption64(P: UInt64, X: UInt64, K: UInt64, G: UInt64, FILE_URL: URL) -> URL?{
    var outputURL: URL? = nil
    let Y: UInt64 = fast_mod64(value: G, power: X, mod: P)
    let YK64_MODP: UInt64 = fast_mod64(value: Y, power: K, mod: P)
    let A: UInt64 = fast_mod64(value: G, power: K, mod: P)
    let ABytes: [UInt8] = UI64toArr8(v: A)
    
    if let data: NSData = NSData(contentsOf: FILE_URL) {
        let blockSize: Int = 65536 // 64KB
        
        var bytesLeft:Int = data.length
        var locationToReadFrom:Int = 0
        var currentBlockSize: Int = 0
        
        // Generating outputURL
        let fileExtention: String = FILE_URL.pathExtension
        let fileName: String = FILE_URL.deletingPathExtension().lastPathComponent
        var buffOutputURL: URL = FILE_URL.deletingLastPathComponent()
        buffOutputURL = buffOutputURL.appendingPathComponent(fileName + "_enc(EG)").appendingPathExtension(fileExtention)
        outputURL = buffOutputURL
        
        do {
            try "".write(to: outputURL!, atomically: true, encoding: .utf8)
        } catch _ {
            
        }
        
        if bytesLeft<blockSize {
            currentBlockSize = bytesLeft
            bytesLeft = 0
        } else {
            currentBlockSize = blockSize
            bytesLeft = bytesLeft - blockSize
        }
        
        while currentBlockSize > 0 {
            var buffer:[UInt8] = Array(repeating: 0, count: currentBlockSize)
            data.getBytes(&buffer, range: NSRange(location: locationToReadFrom, length: currentBlockSize))
            
            // ECRYPYION START
            print("Encrypting \(currentBlockSize) bytes")
            for i in 0...currentBlockSize-1 {
                var buffData: Data = Data(ABytes)
                let B: UInt64 = (YK64_MODP*UInt64(buffer[i]))%P
                buffData.append(Data(UI64toArr8(v: B)))
                
                do {
                    let FH = try FileHandle(forWritingTo: outputURL!)
                    FH.seekToEndOfFile()
                    FH.write(buffData)
                    FH.closeFile()
                } catch let err {
                    print("Error appending to file \(outputURL!)")
                    print(err)
                }
            }
            
            if bytesLeft<blockSize{
                locationToReadFrom = locationToReadFrom + currentBlockSize
                currentBlockSize = bytesLeft
                bytesLeft = 0
            } else {
                locationToReadFrom = locationToReadFrom + currentBlockSize
                currentBlockSize = blockSize
                bytesLeft = bytesLeft - blockSize
            }
        }
        
    }
    
    return outputURL
}

func getInitialSymbolFromAB(A: UInt64, B: UInt64, P: UInt64, X: UInt64) -> UInt64{
    return ((B%P)*(fast_mod64(value: A, power: X*(euler64(of: P)-1), mod: P)))%P
}

func checkDecryptionFile(FILE_URL: URL) -> Bool {
    var ret = false
    if let data: NSData = NSData(contentsOf: FILE_URL) {
        if data.length%16 == 0 {
            ret = true
        }
    }
    return ret
}

func ElGamalDecryption64(P: UInt64, X: UInt64, FILE_URL: URL) -> URL?{
    var outputURL: URL? = nil
    if let data: NSData = NSData(contentsOf: FILE_URL) {
        let blockSize: Int = 65536 // 64KB
        
        var bytesLeft:Int = data.length
        var locationToReadFrom:Int = 0
        var currentBlockSize: Int = 0
        
        // Generating outputURL
        let fileExtention: String = FILE_URL.pathExtension
        let fileName: String = FILE_URL.deletingPathExtension().lastPathComponent
        var buffOutputURL: URL = FILE_URL.deletingLastPathComponent()
        buffOutputURL = buffOutputURL.appendingPathComponent(fileName + "_dec(EG)").appendingPathExtension(fileExtention)
        outputURL = buffOutputURL
        
        do {
            try "".write(to: outputURL!, atomically: true, encoding: .utf8)
        } catch _ {
            
        }
        
        if bytesLeft<blockSize {
            currentBlockSize = bytesLeft
            bytesLeft = 0
        } else {
            currentBlockSize = blockSize
            bytesLeft = bytesLeft - blockSize
        }
        
        while currentBlockSize > 0 {
            var buffer:[UInt8] = Array(repeating: 0, count: currentBlockSize)
            data.getBytes(&buffer, range: NSRange(location: locationToReadFrom, length: currentBlockSize))
            
            // DECRYPYION START
            print("Decrypting \(currentBlockSize) bytes")
            let ABBlockCount: Int = currentBlockSize/16
            var buffByteOutput: [UInt8] = Array(repeating: 0, count: ABBlockCount)
            for i in 0...ABBlockCount-1 {
                let pos: Int = i*16
                let ABytes: [UInt8] = Array(buffer[pos...pos+7])
                let BBytes: [UInt8] = Array(buffer[pos+8...pos+15])
                let A: UInt64 = Arr8toUI64(arr: ABytes)!
                let B: UInt64 = Arr8toUI64(arr: BBytes)!
                let M: UInt64 = getInitialSymbolFromAB(A: A, B: B, P: P, X: X)
                let byte64: UInt64 = 255
                buffByteOutput[i] = UInt8(M&byte64)
            }
            
            do {
                let FH = try FileHandle(forWritingTo: outputURL!)
                FH.seekToEndOfFile()
                FH.write(Data(buffByteOutput))
                FH.closeFile()
            } catch let err {
                print("Error appending to file \(outputURL!)")
                print(err)
            }
            
            if bytesLeft<blockSize{
                locationToReadFrom = locationToReadFrom + currentBlockSize
                currentBlockSize = bytesLeft
                bytesLeft = 0
            } else {
                locationToReadFrom = locationToReadFrom + currentBlockSize
                currentBlockSize = blockSize
                bytesLeft = bytesLeft - blockSize
            }
        }
        
        
    }
    
    return outputURL
}

//func euclid_ex64(a: Int64, b: Int64) -> Int64 {
//    var d0: Int64 = a
//    var d1: Int64 = b
//    var x0: Int64 = 1
//    var x1: Int64 = 0
//    var y0: Int64 = 0
//    var y1: Int64 = 1
//
//    while d1>1 {
//        let q: Int64 = d0/d1
//        let d2: Int64 = d0%d1
//        let x2: Int64 = x0-q*x1
//        let y2: Int64 = y0-q*y1
//
//        d0 = d1
//        d1 = d2
//        x0 = x1
//        x1 = x2
//        y0 = y1
//        y1 = y2
//    }
//    return 0
//}
