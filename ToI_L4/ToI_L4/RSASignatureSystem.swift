//
//  ElGamalSystem.swift
//  ToI_L3
//
//  Created by Михаил Ковалевский on 09.11.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Foundation
import Cocoa

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

func euclid_ex64(a: Int64, b: Int64) -> [Int64] {
    var d0: Int64 = a
    var d1: Int64 = b
    var x0: Int64 = 1
    var x1: Int64 = 0
    var y0: Int64 = 0
    var y1: Int64 = 1

    while d1>1 {
        let q: Int64 = d0/d1
        let d2: Int64 = d0%d1
        let x2: Int64 = x0-q*x1
        let y2: Int64 = y0-q*y1

        d0 = d1
        d1 = d2
        x0 = x1
        x1 = x2
        y0 = y1
        y1 = y2
    }
    
    return [x1,y1,d1]
}

func BSUIRHash64(of str: String, R: UInt64) -> UInt64 {
    var ret: UInt64 = 100
    var index: String.Index = str.startIndex
    while index < str.endIndex {
        var scalarSum: UInt64 = 0
        str[index].unicodeScalars.forEach { (us) in
            scalarSum = scalarSum + UInt64(us.value)
        }
        ret = fast_mod64(value: (ret + scalarSum), power: 2, mod: R)
        index = str.index(after: index)
    }
    return ret
}

func RSASignature64(H: UInt64, R: UInt64, D: UInt64) -> UInt64 {
    return fast_mod64(value: H, power: D, mod: R)
}

func createSignedFile(with_url url: URL, str: String, signature: UInt64, separator: String) -> Bool {
    let writeStr: String = str + separator + String(signature)
    do {
        try writeStr.write(to: url, atomically: true, encoding: .utf8)
    } catch let err {
        print(err)
        return false
    }
    return true
}
