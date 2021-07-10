//
//  HealthManagerStore.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 10/07/2021.
//

import Foundation
import HealthKit

class HealthStore {
    
    // Provide features and functionalitites such as
    // accessing data, accessing and writing number of steps, etc
    var healthStore: HKHealthStore?
    
    
    var hkquery: HKStatisticsCollectionQuery?
    
    
    
    init() {
        // Check whether HealthKit is available on this device.
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        // Types of data, we're requesting from HealthKit
        // In this case we're only using the `stepCount`
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
    
        guard let healthStore = healthStore else { return completion(false) }
        
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            
            completion(success)
        }
        
    }
    
    
    /// Calculate the number of steps,
    /// - Parameter completion: An object that manages a collection of statistics
    ///  each statistics object represents the data calculated over a separate time interval
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // 30 days before the current day
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        
        // anchor date ( Which Time?)
        let anchorDate = Date.mondayAt12AM()
        
        // We want the steps to be calculated daily
        let daily = DateComponents(day: 1)
        
        
        // The search query to allow us to access the sample data from start to end dates
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        
        hkquery = HKStatisticsCollectionQuery(quantityType: stepType,
                                    quantitySamplePredicate: predicate,
                                    options: .cumulativeSum,
                                    anchorDate: anchorDate,
                                    intervalComponents: daily)
        
        hkquery!.initialResultsHandler  = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        
        if let healthStore = healthStore, let query = hkquery {
            healthStore.execute(query)
        }
        
    }
}

extension Date {
    static func mondayAt12AM() -> Date {
        Calendar(identifier: .iso8601)
            .date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
