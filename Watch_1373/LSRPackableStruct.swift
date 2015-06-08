//
//  LSRPackableStruct.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/1/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

public protocol LSRPackableStruct {
    static var packedFieldLength: [Int] { get }
    static var unpackedFieldLength: [Int] { get }
}

public enum LSRPackableStructUtilities {
    private static func makeUInt(value: Any) -> UInt? {
        if        let value = value as? UInt   { return value
        } else if let value = value as? UInt8  { return UInt(value)
        } else if let value = value as? UInt16 { return UInt(value)
        } else if let value = value as? UInt32 { return UInt(value)
        } else if let value = value as? UInt64 { return UInt(value)
        }
        return nil
    }

    private static func packBytes<T : LSRPackableStruct>(strct: T) -> [UInt8] {
        var buffer: [UInt8] = []
        var writeIndex: UInt = 0
        var composingByte: UInt8 = 0

        let mirror = reflect(strct)
        for fieldIndex in 0..<mirror.count {
            let field = mirror[fieldIndex]
            if let readingValue = makeUInt(field.1.value) {
                for var readIndex = 0; readIndex < T.packedFieldLength[fieldIndex]; readIndex++, writeIndex++ {
                    if writeIndex == 8 {
                        buffer.append(composingByte)
                        composingByte = 0
                        writeIndex %= 8
                    }

                    var bit = readingValue & (1 << UInt(readIndex))
                    bit >>= UInt(readIndex)
                    bit <<= writeIndex
                    composingByte |= UInt8(bit)
                }
            } else if let readingValue = field.1.value as? LSR_MsgHeader_t {
                packBytes(readingValue).map(buffer.append)
            } else {
                assert(false, "Field \(field) could not be packed because it is not of a packable type!")
            }
        }

        if writeIndex != 0 {
            buffer.append(composingByte)
        }

        return buffer
    }

    public static func pack<T : LSRPackableStruct>(strct: T) -> NSData {
        var buffer = packBytes(strct)
        return NSData(bytes: &buffer, length: buffer.count)
    }

    public static func unpack<T: LSRPackableStruct>(data: NSData, _ type: T.Type, skipBits: Int = 0) -> T {
        let readBuffer = UnsafeBufferPointer<UInt8>(start: UnsafePointer<UInt8>(data.bytes), count: data.length)
        var writeBuffer: [UInt8] = []
        var readingByte: UInt8 = readBuffer[0]
        var readingByteIndex = 0
        var composingByte: UInt8 = 0

        var writeIndex: UInt8 = 0
        var readIndex: UInt8 = 0

        for i in 0 ..< skipBits {
            if readIndex == 8 {
                readingByte = readBuffer[++readingByteIndex]
                readIndex = 0
            }
            readIndex++
        }

        let mirror = reflect(UnsafeMutablePointer<T>.alloc(1).memory)
        for fieldIndex in 0..<mirror.count {
            let packedLength = T.packedFieldLength[fieldIndex]
            let unpackedLength = T.unpackedFieldLength[fieldIndex]

            for i in 0 ..< packedLength {
                if writeIndex == 8 {
                    writeBuffer.append(composingByte)
                    composingByte = 0
                    writeIndex = 0
                }

                if readIndex == 8 {
                    readingByte = readBuffer[++readingByteIndex]
                    readIndex = 0
                }

                var bit = readingByte & (1 << readIndex)
                bit >>= readIndex
                bit <<= writeIndex
                composingByte |= bit

                writeIndex++
                readIndex++
            }

            for i in packedLength ..< unpackedLength {
                if writeIndex == 8 {
                    writeBuffer.append(composingByte)
                    composingByte = 0
                    writeIndex = 0
                }

                writeIndex++
            }
        }

        if writeIndex > 0 {
            writeBuffer.append(composingByte)
        }

        let newValue = UnsafeMutablePointer<T>(UnsafeMutablePointer<UInt8>(writeBuffer))
        return newValue.memory
    }
}

