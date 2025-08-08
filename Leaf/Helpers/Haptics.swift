//
//  Haptics.swift
//  Leaf
//
//  Created by ddorsat on 31.07.2025.
//

import Foundation
import SwiftUI

struct Haptics {
    static func impact(_ style: Style) {
        switch style {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
        }
    }
    
    enum Style {
        case light, medium, heavy, error, success, warning
    }
}
