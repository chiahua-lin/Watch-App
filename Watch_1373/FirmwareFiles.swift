//
//  FirmwareFiles.swift
//  Watch_1373
//
//  Created by Joe Bonniwell on 5/11/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

func firmwareFileDirectory() -> String
{
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let firmwareFilesDirectory = documentsDirectory.stringByAppendingPathComponent("firmwareFiles")
    NSFileManager.defaultManager().createDirectoryAtPath(firmwareFilesDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)
    
    return firmwareFilesDirectory
}

func allAvailableFirmwareFileNames() -> Array<String>
{
    var availableFirmwareFiles = NSFileManager.defaultManager().contentsOfDirectoryAtPath(firmwareFileDirectory(), error: nil) as? Array<String>
    if availableFirmwareFiles == nil
    {
        availableFirmwareFiles = Array()
    }
    return availableFirmwareFiles!
}

func firmwareDataForFileName(firmwareFileName: String) -> NSData?
{
    let firmwareFilePath = firmwareFileDirectory().stringByAppendingPathComponent(firmwareFileName)
    return NSData(contentsOfFile: firmwareFilePath)
}

func addFirmwareFile(firmwareFileData: NSData, firmwareFileName: String)
{
    firmwareFileData.writeToFile(firmwareFileDirectory().stringByAppendingPathComponent(firmwareFileName), atomically: true)
}