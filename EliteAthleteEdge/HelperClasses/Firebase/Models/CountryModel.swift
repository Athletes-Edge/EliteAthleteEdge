//
//  CountryModel.swift
//  MyReferral
//
//  Created by vision on 19/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

class CountryModel: GenericDictionary {
    var countryName:String
    {
        get{ return stringForKey(key: "countryName")}
        set{setValue(newValue, forKey: "countryName")}
    }
    
    var countryCode:String
    {
        get{ return stringForKey(key: "countryCode")}
        set{setValue(newValue, forKey: "countryCode")}
    }
    
    var countryId:String
    {
        get{ return stringForKey(key: "countryId")}
        set{setValue(newValue, forKey: "countryId")}
    }
}
