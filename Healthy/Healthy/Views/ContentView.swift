//
//  ContentView.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 10/07/2021.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    private var healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
    }
    var body: some View {
        Text("Hello, world!")
            .padding()
            
            
            .onAppear(perform: initilization)
    }
    
    private func initilization() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            // Update UI
                            
                            print(statisticsCollection.statistics())
                        }
                    }
                }
            }
        }
    }
    
    
    private func updateFromStatistics( _ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let endDate = Date()

        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
             let count  = statistics.sumQuantity()?.doubleValue(for: .count())
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
