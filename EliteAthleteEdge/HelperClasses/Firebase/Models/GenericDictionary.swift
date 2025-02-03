//
//  GenericDictionary.swift
//  MyReferral
//
//  Created by vision on 15/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GenericDictionary: NSObject {
    
    var dictionary:[String:Any] = [:]
    
    var snapshot:DocumentSnapshot!
    
    
    
    var docId:String
    {
        let key = self.snapshot.documentID
        return key
    }
    
    func boolForKey(key:String)->Bool
    {
        return self.boolForKey(key: key)!
    }
    
    func boolForKey(key:String,defaultValue:Bool? = false)->Bool?
    {
        return (dictionary[key] as? Bool) ?? defaultValue
    }
    
    func int64ForKey(key:String)->Int64
    {
        return self.int64ForKey(key: key)!
    }
    
    func int64ForKey(key:String,defaultValue:Int64? = nil)->Int64?
    {
        return (dictionary[key] as? Int64) ?? defaultValue
    }
    
    func intForKey(key:String)->Int
    {
        return self.intForKey(key: key, defaultValue: 1)!
    }
    
    func intForKey(key:String,defaultValue:Int?)->Int?
    {
        return (dictionary[key] as? Int) ?? defaultValue
    }
    func floatArrayForKey(key : String) ->[Float]
    {
        return (self.floatArrayForKey(key: key, defaultValue: []))!
    }
    
    func floatArrayForKey(key : String, defaultValue:[Float]?) ->[Float]?
    {
        return (dictionary[key] as? [Float]) ?? defaultValue
    }
    func doubleForKey(key:String)->Double
    {
        return self.douleForKey(key: key) ?? 0.0
    }
    
    func douleForKey(key:String,defaultValue:Double? = nil)->Double?
    {
        return (dictionary[key] as? Double) ?? defaultValue
    }
    func doubleArrayForKey(key:String)->[Double]
    {
        return self.doubleArrayForKey(key: key)!
    }
    
    func doubleArrayForKey(key:String,defaultValue:[Double]? = nil)->[Double]?
    {
        return (dictionary[key] as? [Double]) ?? defaultValue
    }
    
    
    func colorForKey(key:String)->UIColor
    {
        return self.colorForKey(key: key,defaultValue: UIColor.red)!
    }
    
    func colorForKey(key:String,defaultValue:UIColor? = nil)->UIColor?
    {
        return (dictionary[key] as? UIColor) ?? defaultValue
    }
    func stringForKey(key:String)->String
    {
        return self.stringForKey(key: key,defaultValue: "")!
    }
    
    func stringForKey(key:String,defaultValue:String? = nil)->String?
    {
        return (dictionary[key] as? String) ?? defaultValue
    }
    func stringArrayForKey(key:String)->[String]
    {
        return self.stringArrayForKey(key: key)!
    }
    
    func stringArrayForKey(key:String,defaultValue:[String]? = nil)->[String]?
    {
        return (dictionary[key] as? [String]) ?? defaultValue
    }
    
    
//    func styleForKey(key:String)->RevealStyle
//    {
//        return self.styleForKey(key: key,defaultValue: .over)!
//    }
//
//    func styleForKey(key:String,defaultValue:RevealStyle? = .over)->RevealStyle?
//    {
//        return (RevealStyle(rawValue: dictionary[key] as? String ?? RevealStyle.over.rawValue)) ?? defaultValue
//    }
    
    
    func dateForKey(key:String)->Date
    {
        return self.dateForKey(key: key, defaultValue: Date())!
    }
    
    func dateForKey(key:String,defaultValue:Date?)->Date?
    {
        return (dictionary[key] as? Date) ?? defaultValue
    }
    func timeStampForKey(key:String)->Timestamp
    {
        return self.timeStampForKey(key: key, defaultValue: Timestamp(date: Date()))!
    }
    
    func timeStampForKey(key:String,defaultValue:Timestamp?)->Timestamp?
    {
        return (dictionary[key] as? Timestamp) ?? defaultValue
    }
    
    func arrayForKey(key : String) ->[Any]
    {
        return (self.arrayForKey(key: key, defaultValue: []))!
    }
    
    func arrayForKey(key : String, defaultValue:[Any]?) ->[Any]?
    {
        return (dictionary[key] as? [Any]) ?? defaultValue
    }
    
    
    
    func pricesForKey(key : String) ->PricesModel?
    {
        return (self.pricesForKey(key: key))
    }
    func pricesForKey(key : String, defaultValue:PricesModel? = nil) ->PricesModel?
    {
        return (PricesModel(dictionary: dictionary[key] as! [String:Any])) ?? defaultValue
    }
    func userForKey(key : String) ->UserModel?
    {
        return (self.userForKey(key: key))
    }
    func userForKey(key : String, defaultValue:UserModel? = nil) ->UserModel?
    {
        return (dictionary[key] as? UserModel) ?? defaultValue
    }
    
//    func weekDaysarrayForKey(key : String) ->[WeekDay1Model]?
//    {
//        return (self.weekDaysarrayForKey(key: key, defaultValue: [])!)
//    }
//    func weekDaysarrayForKey(key : String, defaultValue:[WeekDay1Model]?) ->[WeekDay1Model]?
//    {
//        return (dictionary[key] as? [WeekDay1Model]) ?? defaultValue
//    }
//    func weekDay1arrayForKey(key : String) ->WeekDay1Model?
//    {
//        return (self.weekDay1arrayForKey(key: key, defaultValue: WeekDay1Model())!)
//    }
//    func weekDay1arrayForKey(key : String, defaultValue:WeekDay1Model?) ->WeekDay1Model?
//    {
//        return (dictionary[key] as? WeekDay1Model) ?? defaultValue
//    }
//    func onlyShowarrayForKey(key : String) ->[OnlyShowModel]?
//    {
//        return (self.onlyShowarrayForKey(key: key, defaultValue: [])!)
//    }
//    func onlyShowarrayForKey(key : String, defaultValue:[OnlyShowModel]?) ->[OnlyShowModel]?
//    {
//        return (dictionary[key] as? [OnlyShowModel]) ?? defaultValue
//    }
    
    func dictForKey(key : String) ->[String : Any]
    {
        return self.dictForKey(key: key, defaultValue: [:])!
        //        return (dictionary[key] as? [String : Any])!
    }
    
    func dictForKey(key : String, defaultValue:[String : Any]?) ->[String : Any]?
    {
        return (dictionary[key] as? [String : Any]) ?? defaultValue
    }
    func arrayDicForKey(key : String) ->[[String:Any]]
    {
        return (self.arrayDicForKey(key: key, defaultValue: []))!
    }
    
    func arrayDicForKey(key : String, defaultValue:[[String:Any]]?) ->[[String:Any]]?
    {
        return (dictionary[key] as? [[String:Any]]) ?? defaultValue
    }
    
    
    func stringDictForKey(key : String) ->[String : String]
    {
        return self.stringDictForKey(key: key, defaultValue: [:])!
        //        return (dictionary[key] as? [String : Any])!
    }
    
    func stringDictForKey(key : String, defaultValue:[String : String]?) ->[String : String]?
    {
        return (dictionary[key] as? [String : String]) ?? defaultValue
    }
    
    
    
    func boolDictForKey(key : String) ->[String : Bool]
    {
        return self.boolDictForKey(key: key, defaultValue: [:])!
        //        return (dictionary[key] as? [String : Any])!
    }
    
    func boolDictForKey(key : String, defaultValue:[String : Bool]?) ->[String : Bool]?
    {
        return (dictionary[key] as? [String : Bool]) ?? defaultValue
    }
    func int64DictForKey(key : String) ->[String : Int64]
    {
        return self.int64DictForKey(key: key, defaultValue: [:])!
        //        return (dictionary[key] as? [String : Any])!
    }
    
    func int64DictForKey(key : String, defaultValue:[String : Int64]?) ->[String : Int64]?
    {
        return (dictionary[key] as? [String : Int64]) ?? defaultValue
    }
    func doubleDictForKey(key : String) ->[String : Double]
    {
        return self.doubleDictForKey(key: key, defaultValue: [:])!
        //        return (dictionary[key] as? [String : Any])!
    }
    
    func doubleDictForKey(key : String, defaultValue:[String : Double]?) ->[String : Double]?
    {
        return (dictionary[key] as? [String : Double]) ?? defaultValue
    }
    override func setValue(_ value: Any?, forKey key: String) {
        dictionary[key] = value
    }
    
    required init?(snap:DocumentSnapshot) {
        super.init()
        self.snapshot = snap;
        self.dictionary = snap.data() ?? [:]
    }
    
    init?(dictionary:[String:Any]) {
        super.init()
//        self.snapshot = QueryDocumentSnapshot();
        self.dictionary = dictionary 
    }
    

    override init(){
        super.init()
//        self.snapshot = QueryDocumentSnapshot();
        self.dictionary = [:]
    }
    
    
    
    @nonobjc
    convenience init(otherDictionaryObject: GenericDictionary) {
        self.init(snap: otherDictionaryObject.snapshot)!
    }
    
    func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(snap: snapshot)!
        
    }
    
    
    override var hash: Int {return (dictionary as NSObject).hash}
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? GenericDictionary else {return false}
        return self.isEqual(to: other)
    }
    
    func isEqual(to dictionaryModelObject: GenericDictionary) -> Bool {
        guard type(of: dictionaryModelObject) == type(of: self) else {return false}
        return (dictionary as NSObject).isEqual(dictionaryModelObject.dictionary as NSObject)
    }
}
