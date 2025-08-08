//
//  Extensions.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import Foundation
import UIKit
import SwiftUI

extension UIDevice {
    static var isProMax: Bool {
        UIScreen.main.bounds.width >= 430
    }
}

extension UIColor {
    static func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Date {
    var relativeDate: String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")

        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")

        if calendar.isDateInToday(self) {
            return "Сегодня"
        } else if calendar.isDateInYesterday(self) {
            return "Вчера"
        } else if isCurrentWeek {
            df.setLocalizedDateFormatFromTemplate("EEEE, d MMMM")
            return df.string(from: self).capitalized
        } else if isCurrentYear {
            df.setLocalizedDateFormatFromTemplate("d MMMM")
            return df.string(from: self)
        } else {
            df.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
            return df.string(from: self)
        }
    }

    private var isCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekday)
    }

    private var isCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
    
