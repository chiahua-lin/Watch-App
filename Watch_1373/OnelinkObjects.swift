//
//  OnelinkObjects.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation


struct Contact {
    var name:String
    var profilePicture:UIImage
    var phoneNumber:String
    var selected:Bool
}


struct Profile {
    var name:String
    var birthdate:NSDate
    var heightInInches:Int
    var weight:Int
    var hair:HairColor
    var eyes:EyeColor
    var race:Race
    var profilePicture:UIImage
}

struct User {
    var fullName:String
    var phoneNumber:String
    var activated:Bool
    var password:String
    var email:String
    var userID:String
}