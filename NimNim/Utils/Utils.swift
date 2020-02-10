//
//  Utils.swift
//  NimNim
//
//  Created by Raghav Vij on 15/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

var model : CartModel?

func addServiceToCartAliasinUserDefaults(withAlias alias : String?) // written in all services screen and called whenever add to cart or update cart is called.
{
    if let alias = alias {
        if var aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {  // alias array is an array of string ....ie ["wash and fold","waash and air Dry" etc]
            if !aliasArray.contains(alias)
            {
                aliasArray.append(alias)
                UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
            }
        }
        else
        {
            let aliasArray = [alias]
            UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
        }
    }
}

func setupAliasArray(withValue aliases:[String]?) {
    if let aliases = aliases {
        UserDefaults.standard.set(aliases, forKey: UserDefaultKeys.cartAlias)
    }
}

func setupAliasesFromCart(withModel model:CartModel?)  {
    if let cartModel = model {
        if let services = cartModel.services {
            let aliases = services.map { (serviceModel) -> String in
                return serviceModel.alias ?? ""
            }
            setupAliasArray(withValue: aliases)
        }
    }
}

func removeServiceFromCartAliasInUserDefault(withAlias alias:String?) {
    if let alias = alias {
        if var aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {  // alias array is an array of string ....ie ["wash and fold","waash and air Dry" etc]
            if aliasArray.contains(alias)
            {
                //This function will loop over all the values inside the alias array... and the closure will be called for every value(aliasValue parameter of the closure) inside the array... all those values will be removed from the aliasArray for which the closure will return true... this means in our case all the values that match the service alias inside the array will be removed...
                aliasArray.removeAll { (aliasValue) -> Bool in
                    return aliasValue == alias
                }
                UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
            }
        }
        else
        {
            let aliasArray = [alias]
            UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
        }
    }
}

func fetchNoOfServicesInCart() -> Int { //// written in cart icon updation.
    if let array =  UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {
        return array.count
    }
    return 0
}

func checkIfInCart(withAlias alias : String) -> Bool
{
    if let aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {
        if aliasArray.contains(alias)
        {
            return true
        }
        else
        {
            return false
        }
    }
    return false
}

func fetchFirstValidPickupDate() -> Date {
    let currentDate = Date() // gives current date
    let hourFactor = 2 //Hour Window for pickup to start
    let calendar = Calendar.current
    if let probablePickupDate = calendar.date(byAdding: .hour, value: hourFactor, to: currentDate)  {
        let firstDateForMorningSlotOfToday = fetchDateSlot(forHour: 7, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let lastDateForMorningSlotOfToday = fetchDateSlot(forHour: 13, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let firstDateForEveningSlotOfToday = fetchDateSlot(forHour: 16, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let lastDateForEveningSlotOfToday = fetchDateSlot(forHour: 22, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let endOfDay = fetchDateSlot(forHour: 24, ofDate: probablePickupDate) // This will give date value for 7am of today....
        
        if isDate(concernedDate: probablePickupDate, betweenDatesDate1: firstDateForMorningSlotOfToday, andDate2: lastDateForMorningSlotOfToday) {
            print("user has chosen some morning slot") //  7AM-1PM
            return probablePickupDate
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: firstDateForEveningSlotOfToday, andDate2: lastDateForEveningSlotOfToday) {
            print("user has chosen some evening slot") //4PM-10PM
            return probablePickupDate
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: lastDateForMorningSlotOfToday, andDate2: firstDateForEveningSlotOfToday) {
            print("user has chosen some in between slot...so give him evening first slot...") // 1PM-4PM
            let slot = fetchDateSlot(forHour: 16, ofDate: probablePickupDate)
            return slot
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: lastDateForEveningSlotOfToday, andDate2: endOfDay) {
            print("user has chosen some time between 10PM - 12AM...show him next day morning slot...")
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                let slot = fetchDateSlot(forHour: 7, ofDate: nextDate)
                return slot
            }else {
                print("should never come here")
                return Date()
            }
        }else {
            print("user has chosen some time between 12AM - 7AM...show him that day morning slot...")
            let slot = fetchDateSlot(forHour: 7, ofDate: probablePickupDate)
            return slot
        }
    }else {
        //should never come here
        print("should never come here")
        return Date()
    }
}// this function gives the first probable date to be used in calculation of the time slots. There are three special cases of time 12am-7am  , 10pm - 12am ,1PM-4PM.

func fetchFirstValidDropOffDate(withInitialDate date:Date, withTurnaroundTime turnaroundHour:Int) -> Date {
    let currentDate = date // gives current date
    let hourFactor = turnaroundHour //Hour Window for pickup to start
    let calendar = Calendar.current
    if let probablePickupDate = calendar.date(byAdding: .hour, value: hourFactor, to: currentDate)  {
        let firstDateForMorningSlotOfToday = fetchDateSlot(forHour: 7, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let lastDateForMorningSlotOfToday = fetchDateSlot(forHour: 13, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let firstDateForEveningSlotOfToday = fetchDateSlot(forHour: 16, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let lastDateForEveningSlotOfToday = fetchDateSlot(forHour: 22, ofDate: probablePickupDate) // This will give date value for 7am of today....
        let endOfDay = fetchDateSlot(forHour: 24, ofDate: probablePickupDate) // This will give date value for 7am of today....
        
        if isDate(concernedDate: probablePickupDate, betweenDatesDate1: firstDateForMorningSlotOfToday, andDate2: lastDateForMorningSlotOfToday) {
            print("user has chosen some morning slot") //  7AM-1PM
            return probablePickupDate
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: firstDateForEveningSlotOfToday, andDate2: lastDateForEveningSlotOfToday) {
            print("user has chosen some evening slot") //4PM-10PM
            return probablePickupDate
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: lastDateForMorningSlotOfToday, andDate2: firstDateForEveningSlotOfToday) {
            print("user has chosen some in between slot...so give him evening first slot...") // 1PM-4PM
            let slot = fetchDateSlot(forHour: 16, ofDate: probablePickupDate)
            return slot
        }else if isDate(concernedDate: probablePickupDate, betweenDatesDate1: lastDateForEveningSlotOfToday, andDate2: endOfDay) {
            print("user has chosen some time between 10PM - 12AM...show him next day morning slot...")
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                let slot = fetchDateSlot(forHour: 7, ofDate: nextDate)
                return slot
            }else {
                print("should never come here")
                return Date()
            }
        }else {
            print("user has chosen some time between 12AM - 7AM...show him that day morning slot...")
            let slot = fetchDateSlot(forHour: 7, ofDate: probablePickupDate)
            return slot
        }
    }else {
        //should never come here
        print("should never come here")
        return Date()
    }
}

func fetchSlots(forDate date:Date) -> [Date] {
    var slots:[Date] = []
    let validSlot1 = fetchDateSlot(forHour: 7, ofDate: date)
    let validSlot2 = fetchDateSlot(forHour: 9, ofDate: date)
    let validSlot3 = fetchDateSlot(forHour: 11, ofDate: date)
    let validSlot4 = fetchDateSlot(forHour: 13, ofDate: date)
    let validSlot5 = fetchDateSlot(forHour: 16, ofDate: date)
    let validSlot6 = fetchDateSlot(forHour: 18, ofDate: date)
    let validSlot7 = fetchDateSlot(forHour: 20, ofDate: date)
    let validSlot8 = fetchDateSlot(forHour: 22, ofDate: date)
    
    if isDate(concernedDate: date, betweenDatesDate1: validSlot1, andDate2: validSlot2) {
        //7-10AM
        slots.append(validSlot1) //7-9
        slots.append(validSlot2) //9-11
        slots.append(validSlot3) //11-13
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot2, andDate2: validSlot3) {
        //10-1PM
        slots.append(validSlot2) //9-11
        slots.append(validSlot3) //11-13
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot3, andDate2: validSlot4) {
        //4-7PM
        slots.append(validSlot3) //11-13
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot4, andDate2: validSlot5) {
        //7-10PM
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot5, andDate2: validSlot6) {
        //7-10PM
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot5, andDate2: validSlot6) {
        //7-10PM
        slots.append(validSlot5)//16-18
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot6, andDate2: validSlot7) {
        //7-10PM
        slots.append(validSlot6)//18-20
        slots.append(validSlot7)//20-22
    }else if isDate(concernedDate: date, betweenDatesDate1: validSlot7, andDate2: validSlot8) {
        //7-10PM
        slots.append(validSlot7)//20-22
    }
    return slots
} // this function associates date slots with the  concerened date. it appends  all the possible date slots for that date. Later wee are extracting the hour portion of the fetched dates.

func slotString(forDateSlot date:Date) -> String {
    var calendar = Calendar.current
    let timeZone = TimeZone.current
    calendar.timeZone = timeZone
    if let hour = calendar.dateComponents([.hour], from: date).hour {
        if hour == 7 {
            return "7AM - 9AM"
        }else if hour == 9 {
            return "9AM - 11AM"
        }else if hour == 11 {
            return "11AM - 1PM"
        }else if hour == 16 {
            return "4PM - 6PM"
        }else if hour == 18 {
            return "6PM - 8PM"
        }else if hour == 20 {
            return "8PM - 10PM"
        }
    
    }
    return ""
}//// this function returns the string against the date.

func fetchValidPickupDates() -> [Date] {
    var dates:[Date] = []
    let firstDate = fetchFirstValidPickupDate()
    let calendar = Calendar.current
    for i in 0..<10 {
        if let nextDate = calendar.date(byAdding: .day, value: i, to: firstDate) {
            if i == 0 {
               dates.append(nextDate)
            }else {
               let newDate = fetchDateSlot(forHour: 7, ofDate: nextDate)
               dates.append(newDate)
            }
            
        }
    }
    return dates
} // this function gives us the next ten dates......

func fetchValidDropOffDates(withInitialDate initialDate:Date, withTurnaroundTimeInHr turnaroudTime:Int) -> [Date] {
    var dates:[Date] = []
    
    let firstDate = fetchFirstValidDropOffDate(withInitialDate: initialDate, withTurnaroundTime: turnaroudTime)
    let calendar = Calendar.current
    for i in 0..<10 {
        if let nextDate = calendar.date(byAdding: .day, value: i, to: firstDate) {
            if i == 0 {
               dates.append(nextDate)
            }else {
               let newDate = fetchDateSlot(forHour: 7, ofDate: nextDate)
               dates.append(newDate)
            }
            
        }
    }
    return dates
}

func isDate(concernedDate date:Date, betweenDatesDate1 date1:Date, andDate2 date2:Date) -> Bool
{
    return (date.compare(date1) == .orderedDescending || date.compare(date1) == .orderedSame) && (date.compare(date2) == .orderedAscending || date.compare(date2) == .orderedSame)
} // this function gives us true or false if the concerned date is between date1 and  date2.

func fetchDateSlot(forHour hour:Int, ofDate date:Date) -> Date {
    var calendar = Calendar.current
    let timeZone = TimeZone.current
    calendar.timeZone = timeZone
    var dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date)
    dateComponents.hour = hour
    dateComponents.minute = 0
    if let date = calendar.date(from: dateComponents) {
        return date
    }else {
        return Date()
    }
} // this function helps us to create any date with the desired datecomponent.

func dateValue(byaddingHours hours:Int, toDate date:Date) -> Date? {
    let calendar = Calendar.current
    if let finalDate = calendar.date(byAdding: .hour, value: hours, to: date) {
        return finalDate
    }
    return nil
}
