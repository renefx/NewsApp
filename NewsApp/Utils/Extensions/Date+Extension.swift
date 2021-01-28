//
//  Date+Extension.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import Foundation

extension Date {
    static func timeFormatter(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: myDate)
    }
    
    static func dateFormatter(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: myDate)
    }
}
