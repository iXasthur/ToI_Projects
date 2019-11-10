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

func ElGamalEncryption(P: UInt64, X: UInt64, K: UInt64, G: UInt64, FILE_URL: URL) -> URL?{
    var outputURL: URL? = nil
    if let data: NSData = NSData(contentsOf: FILE_URL) {
        let dataToAppend: NSMutableData = NSMutableData()
        let blockSize: Int = 65536 // 64KB
        
        var bytesLeft:Int = data.length
        var locationToReadFrom:Int = 0
        var currentBlockSize: Int = 0
        
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
            
            dataToAppend.append(Data(buffer))
            
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
