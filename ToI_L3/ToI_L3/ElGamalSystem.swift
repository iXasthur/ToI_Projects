//
//  ElGamalSystem.swift
//  ToI_L3
//
//  Created by Михаил Ковалевский on 09.11.2019.
//  Copyright © 2019 Mikhail Kavaleuski. All rights reserved.
//

import Foundation

func fast_mod64(value: Int64, power: Int64, mod: Int64) -> Int64 {
    var v: Int64 = value;
    var p: Int64 = power;
    var x: Int64 = 1;
    
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

func euler64(of v: Int64) -> Int64 {
    var result: Int64 = v
    var n: Int64 = v
    
    var i: Int64 = 2
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

func isPrimitiveDivider(v: Int64, of n: Int64) -> Bool {
    var ret: Bool = false
    if (n%v==0) && (euler64(of: v) == v-1) {
        ret = true
    }
    return ret
}

func getPrimitiveRoots(of v: Int64) -> [Int64]{
    var buffArr: [Int64] = []
    if v>2 {
        var primitiveDividers: [Int64] = []
        for i: Int64 in 2...(v-1)/2+1{
            if (isPrimitiveDivider(v: i, of: v-1)) {
                primitiveDividers.append(i)
            }
        }
//        print("Primitive dividers of (\(v)-1):",primitiveDividers)
        
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
        } else {
            
        }
    } else
        if v == 2 {
            buffArr = [1]
        }
    return buffArr
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
