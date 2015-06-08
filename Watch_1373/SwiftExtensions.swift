//
//  SwiftExtensions.swift
//  Watch_1373
//
//  Created by William LaFrance on 3/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

typealias VoidCallback = () -> Void

/* Adapted from
 * https://gist.github.com/nubbel/d5a3639bea96ad568cf2
 */
extension Range {
    func toArray() -> [T] {
        return [T](self)
    }
}

extension Array {
    func randomElement() -> (Int, T)? {
        return randomElementExceptIndices([])
    }

    func randomElementExceptIndices(forbiddenIndices: [Int]) -> (Int, T)? {
        let allIndices = (startIndex ..< endIndex).toArray()
        let validIndices = allIndices.filter { !contains(forbiddenIndices, $0) }

        if validIndices.count == 0 {
            return nil
        }

        let index = randomUniform(validIndices.count)

        return (index, self[validIndices[index]])
    }
}

/**
 * A Box is necessary for holding non-fixed multi-payload enum layouts such as in Result<T, U>.
 */
class Box<T> {
    let contents: T

    init(_ contents: T) { self.contents = contents }
}

/**
 * When an operation can return either success or failure it can return a Result<T, U> to force the caller to check both
 * options.
 */
enum Result<T, U> {
    case _Success(Box<T>)
    case _Failure(Box<U>)

    static func Success(t: T) -> Result { return ._Success(Box(t)) }
    static func Failure(u: U) -> Result { return ._Failure(Box(u)) }

    func onSuccess(action: (T) -> ()) -> Result {
        switch self {
            case let ._Success(box):
                action(box.contents)
            default: let nop = 0
        }
        return self
    }

    func onFailure(action: (U) -> ()) -> Result {
        switch self {
            case let ._Failure(box):
                action(box.contents)
            default: let nop = 0
        }
        return self
    }
}

func randomUniform(upperBound: Int) -> Int {
    return Int(arc4random_uniform(UInt32(upperBound)))
}

func reflectionDescribe<T>(thing: T) -> String {
    let mirror = reflect(thing)
    let fields = (0 ..< mirror.count).toArray().map { fieldIndex -> String in
        let field = mirror[fieldIndex]
        return "\(field.0): \(field.1.value)"
    }
    return ", ".join(fields)
}
