//
//  Extensions.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        Calendar(identifier: .iso8601)
            .date(from: Calendar(identifier: .iso8601)
                    .dateComponents([.yearForWeekOfYear, .weekOfYear],
                                    from: Date()
                    )
            )!
    }
}

extension HealthKit.HKBloodTypeObject {
    // Convert a HKBloodType to a human readable format
    public func readableBloodType() -> String {
        switch self.bloodType {
        case .aPositive: return "A+"
        case .aNegative: return "A-"
        case .bPositive: return "B+"
        case .bNegative: return "B-"
        case .abPositive: return "AB+"
        case .abNegative: return "AB-"
        case .oPositive: return "O+"
        case .oNegative: return "O-"
        default: return "Unknown"
        }
    }
}
