//
//  dsxs+Date.swift
//  dsxs
//
//  Created by dsxs on 2017/12/14.
//

import Foundation
extension Date{
    static let formats:[String] = [
        "yyyy-MM",
        "yyyy-MM-dd",
        "yyyy-MM-ddHH:mm:ss",
        "yyyy年MM月dd日",
        "yyyy-MM-ddHH:mm:ssZZZ",
        "yyyy-MM-dd'T'HH:mm:ssZZZ",
        "yyyy-MM-dd'T'HH:mm:ssZ",
        "yyyy-MM-dd HH:mm:ss VV"
    ]
    static let formatter = DateFormatter()
    public static var thisMonth:Date{
        let fmt = "yyyyMM"
        return Date(Date().toString(fmt), format:fmt)!
    }
    public static var today:Date{
        let fmt = "yyyyMMdd"
        return Date(Date().toString(fmt), format:fmt)!
    }
    
    
    public init?(_ timeString:String, format fmt:String?=nil){
        let df = Date.formatter
        if fmt != nil{
            df.dateFormat = fmt
            if let d = df.date(from: timeString){
                self = d
                return
            }
        }
        for format in Date.formats{
            df.dateFormat = format
            if let d = df.date(from: timeString){
                self = d
                return
            }
        }
        return nil
    }
    
    public func toString(_ format:String="yyyy-MM-ddHH:mm:ss", locale:Locale=Locale.JP)-> String{
        let df = Date.formatter
        df.dateFormat = format
        df.locale = locale
        return df.string(from: self)
    }
}
