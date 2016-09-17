//
//  DateExtensions.swift
//
//  Created by Robert Nix on 6/18/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

import Foundation

// Define methods that allow us to add and subtract
// NSDateComponents instances

// The addition and subtraction code is nearly the same,
// so we've factored it out into this method
func combineComponents(lhs: NSDateComponents,
                       rhs: NSDateComponents,
                       _ multiplier: Int = 1)
    -> NSDateComponents
{
    let result = NSDateComponents()
    let undefined = Int(NSDateComponentUndefined)
    
    result.second = ((lhs.second != undefined ? lhs.second : 0) +
        (rhs.second != undefined ? rhs.second : 0) * multiplier)
    result.minute = ((lhs.minute != undefined ? lhs.minute : 0) +
        (rhs.minute != undefined ? rhs.minute : 0) * multiplier)
    result.hour = ((lhs.hour != undefined ? lhs.hour : 0) +
        (rhs.hour != undefined ? rhs.hour : 0) * multiplier)
    result.day = ((lhs.day != undefined ? lhs.day : 0) +
        (rhs.day != undefined ? rhs.day : 0) * multiplier)
    result.month = ((lhs.month != undefined ? lhs.month : 0) +
        (rhs.month != undefined ? rhs.month : 0) * multiplier)
    result.year = ((lhs.year != undefined ? lhs.year : 0) +
        (rhs.year != undefined ? rhs.year : 0) * multiplier)
    return result
}

// With combineComponents defined,
// overloading + and - is simple

func +(lhs: NSDateComponents, rhs: NSDateComponents) -> NSDateComponents
{
    return combineComponents(lhs, rhs: rhs)
}

func -(lhs: NSDateComponents, rhs: NSDateComponents) -> NSDateComponents
{
    return combineComponents(lhs, rhs: rhs, -1)
}

// We'll need to overload unary - so we can negate components
prefix func -(components: NSDateComponents) -> NSDateComponents {
    let result = NSDateComponents()
    let undefined = Int(NSDateComponentUndefined)
    
    if(components.second != undefined) { result.second = -components.second }
    if(components.minute != undefined) { result.minute = -components.minute }
    if(components.hour != undefined) { result.hour = -components.hour }
    if(components.day != undefined) { result.day = -components.day }
    if(components.month != undefined) { result.month = -components.month }
    if(components.year != undefined) { result.year = -components.year }
    return result
}

// Let's make it easy to add dates and components,
// and subtract components from dates

// Date + component
func +(lhs: NSDate, rhs: NSDateComponents) -> NSDate
{
    return NSCalendar.currentCalendar().dateByAddingComponents(rhs,
                                                               toDate: lhs,
                                                               options: [])!
}

// Component + date
func +(lhs: NSDateComponents, rhs: NSDate) -> NSDate
{
    return rhs + lhs
}

// Date - component
// (Component - date doesn't make sense)
func -(lhs: NSDate, rhs: NSDateComponents) -> NSDate
{
    return lhs + (-rhs)
}


// Next, we extend Int to bring some Ruby-like magic
// to date components

extension Int {
    
    var seconds: NSDateComponents {
        let components = NSDateComponents()
        components.second = self;
        return components
    }
    
    var second: NSDateComponents {
        return self.seconds
    }
    
    var minutes: NSDateComponents {
        let components = NSDateComponents()
        components.minute = self;
        return components
    }
    
    var minute: NSDateComponents {
        return self.minutes
    }
    
    var hours: NSDateComponents {
        let components = NSDateComponents()
        components.hour = self;
        return components
    }
    
    var hour: NSDateComponents {
        return self.hours
    }
    
    var days: NSDateComponents {
        let components = NSDateComponents()
        components.day = self;
        return components
    }
    
    var day: NSDateComponents {
        return self.days
    }
    
    var weeks: NSDateComponents {
        let components = NSDateComponents()
        components.day = 7 * self;
        return components
    }
    
    var week: NSDateComponents {
        return self.weeks
    }
    
    var months: NSDateComponents {
        let components = NSDateComponents()
        components.month = self;
        return components
    }
    
    var month: NSDateComponents {
        return self.months
    }
    
    var years: NSDateComponents {
        let components = NSDateComponents()
        components.year = self;
        return components
    }
    
    var year: NSDateComponents {
        return self.years
    }
    
}

extension NSDate {
    
    func diff(date : NSDate) -> NSDateComponents {
        let result : NSDateComponents
        let normSdate = self.normalize()
        let normEdate = date.normalize()
        if ((NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: normSdate, toDate: normEdate, options: NSCalendarOptions.MatchFirst)).day > 0) {
            result = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: normSdate, toDate: normEdate, options: NSCalendarOptions.MatchFirst)
        } else {
            result = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: normEdate, toDate: normSdate, options: NSCalendarOptions.MatchFirst)
        }
        return result
    }
    
    func offset(offsetAmount : Int) -> NSDate {
        let newDate = self.normalize() + offsetAmount.days
        return newDate
    }
    
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
  
  func normalize() -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([ .Year, .Month, .Day ] , fromDate: self)
    return calendar.dateFromComponents(components)!
  }
    
}
