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
}
