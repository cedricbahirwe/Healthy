//
//  HealthManagerStore.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 10/07/2021.
//

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
        // The number of steps
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        // The data of birth
        let dob = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        // The blood type
        let bloodType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!
        // The body mass
        let bodyMass = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        
        
        let hkTypesToRead: Set<HKObjectType> = [stepType, dob, bloodType, bodyMass]
        let hkTypesToWrite: Set<HKSampleType> = [bodyMass]
        
        guard let healthStore = healthStore else { return completion(false) }
        
        
        healthStore.requestAuthorization(toShare: hkTypesToWrite,
                                         read: hkTypesToRead) { (success, error) in
            
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
        
        // anchor date (Which Time?)
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
    
    
    /// Get Infor from HealthKit
    /// - Returns: the age and bloodType of the user
    
    func getInfo() -> (age: Int?, bloodType: HKBloodTypeObject?) {
        var age: Int?
        var blootype: HKBloodTypeObject?
        
        do {
            let birthDate = try healthStore!.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            age = currentYear - birthDate.year!
            blootype = try healthStore!.bloodType()
            
        } catch { }
        
        return (age, blootype)
    }
    
    
    
    /// Save a given weight to HealthKit
    /// - Parameters:
    ///   - weight: the weight to be saved in `grams`
    ///   - completion: a closure that indicates whether the saving operation was successul
    func saveBodyMass(weight: Double, completion: @escaping(Bool) -> Void) {
        
        let today = Date()
        
        if let type = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            let quantity = HKQuantity(unit: .gram(), doubleValue: weight)
            
            let sample = HKQuantitySample(type: type,
                                          quantity: quantity,
                                          start: today,
                                          end: today)
            
            healthStore?.save(sample, withCompletion: { (success, error) in
                completion(success)
            })
        }
    }
    
    
    func getBodyMass(completion: @escaping(String) -> Void) {
        print("up")
        var weight: String = ""
        let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass)!
        let query = HKSampleQuery(sampleType: weightType,
                                  predicate: nil,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                print("weight -> \(result.quantity)")
                DispatchQueue.main.async {
                    weight = "\(result.quantity)"
                    completion(weight)
                }
            } else {
                print("We could not retrieve the result \nResults => \(String(describing: results)), error => \(String(describing: error)))")
            }
        }
        
        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
}
