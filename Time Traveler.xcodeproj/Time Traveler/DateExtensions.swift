//
//  DateExtensions.swift
//
//  Created by Robert Nix on 6/18/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

import Foundation

// Define methods that allow us to add and subtract
// DateComponents instances

// The addition and subtraction code is nearly the same,
// so we've factored it out into this method
func combineComponents(_ lhs: DateComponents,
                       rhs: DateComponents,
                       _ multiplier: Int = 1)
    -> DateComponents
{
    var result = DateComponents()
    let undefined = Int(NSDateComponentUndefined)
    
    result.second = ((lhs.second! != undefined ? lhs.second! : 0) +
        (rhs.second! != undefined ? rhs.second! : 0) * multiplier)
    result.minute = ((lhs.minute! != undefined ? lhs.minute! : 0) +
        (rhs.minute! != undefined ? rhs.minute! : 0) * multiplier)
    result.hour = ((lhs.hour! != undefined ? lhs.hour! : 0) +
        (rhs.hour! != undefined ? rhs.hour! : 0) * multiplier)
    result.day = ((lhs.day! != undefined ? lhs.day! : 0) +
        (rhs.day! != undefined ? rhs.day! : 0) * multiplier)
    result.month = ((lhs.month! != undefined ? lhs.month! : 0) +
        (rhs.month! != undefined ? rhs.month! : 0) * multiplier)
    result.year = ((lhs.year! != undefined ? lhs.year! : 0) +
        (rhs.year! != undefined ? rhs.year! : 0) * multiplier)
    return result
}

// With combineComponents defined,
// overloading + and - is simple

func +(lhs: DateComponents, rhs: DateComponents) -> DateComponents
{
    return combineComponents(lhs, rhs: rhs)
}

func -(lhs: DateComponents, rhs: DateComponents) -> DateComponents
{
    return combineComponents(lhs, rhs: rhs, -1)
}

// We'll need to overload unary - so we can negate components
prefix func -(components: DateComponents) -> DateComponents {
    var result = DateComponents()
    let undefined = Int(NSDateComponentUndefined)
    
    if(components.second != undefined) { result.second = -components.second! }
    if(components.minute != undefined) { result.minute = -components.minute! }
    if(components.hour != undefined) { result.hour = -components.hour! }
    if(components.day != undefined) { result.day = -components.day! }
    if(components.month != undefined) { result.month = -components.month! }
    if(components.year != undefined) { result.year = -components.year! }
    return result
}

// Let's make it easy to add dates and components,
// and subtract components from dates

// Date + component
func +(lhs: Date, rhs: DateComponents) -> Date
{
    return (Calendar.current as Calendar).date(byAdding: rhs, to: lhs)!
}

// Component + date
func +(lhs: DateComponents, rhs: Date) -> Date
{
    return rhs + lhs
}

// Date - component
// (Component - date doesn't make sense)
func -(lhs: Date, rhs: DateComponents) -> Date
{
    return lhs + (-rhs)
}


// Next, we extend Int to bring some Ruby-like magic
// to date components

extension Int {
    
    var seconds: DateComponents {
        var components = DateComponents()
        components.second = self;
        return components
    }
    
    var second: DateComponents {
        return self.seconds
    }
    
    var minutes: DateComponents {
        var components = DateComponents()
        components.minute = self;
        return components
    }
    
    var minute: DateComponents {
        return self.minutes
    }
    
    var hours: DateComponents {
        var components = DateComponents()
        components.hour = self;
        return components
    }
    
    var hour: DateComponents {
        return self.hours
    }
    
    var days: DateComponents {
        var components = DateComponents()
        components.day = self;
        return components
    }
    
    var day: DateComponents {
        return self.days
    }
    
    var weeks: DateComponents {
        var components = DateComponents()
        components.day = 7 * self;
        return components
    }
    
    var week: DateComponents {
        return self.weeks
    }
    
    var months: DateComponents {
        var components = DateComponents()
        components.month = self;
        return components
    }
    
    var month: DateComponents {
        return self.months
    }
    
    var years: DateComponents {
        var components = DateComponents()
        components.year = self;
        return components
    }
    
    var year: DateComponents {
        return self.years
    }
    
}

extension Date {
    
    func normalize() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([ .year, .month, .day ] , from: self)
        return calendar.date(from: components)!
    }
    
    func diff(_ date : Date) -> DateComponents {
        let result : DateComponents
        let normSdate = self.normalize()
        let normEdate = date.normalize()
        if (normSdate.compare(normEdate) == .orderedAscending) {
                result = (Calendar.current as NSCalendar).components([.year, .month, .day], from: normSdate, to: normEdate, options: NSCalendar.Options.matchFirst)
        } else {
            result = (Calendar.current as NSCalendar).components([.year, .month, .day], from: normEdate, to: normSdate, options: NSCalendar.Options.matchFirst)
        }
        return result
    }
    
    func offset(_ offsetAmount : Int) -> Date {
        let newDate = self.normalize() + offsetAmount.days
        return newDate
    }
    
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
  
}
