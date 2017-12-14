//
//  dsxs+String.swift
//  dsxs
//
//  Created by dsxs on 2017/12/14.
//

import Foundation

extension String {
    public func match(_ regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
    public func toDate(dateFormat:String) -> Date?{
        let formatter = Date.formatter
        formatter.dateFormat = dateFormat
        
        return formatter.date(from: self)
    }

    public func replace(_ pattern: String, with tmp: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: tmp)
    }
}
