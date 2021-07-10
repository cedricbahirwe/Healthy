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
    
    @State private var steps: [Step] = []
    
    init() {
        healthStore = HealthStore()
    }
    var body: some View {
        
        NavigationView {
            List(steps) { step in
                VStack(alignment: .leading) {
                Text("Steps: \(step.count)")
                    .font(Font.title3)
                    .fontWeight(.bold)
                Text(step.date, style: .date)
                    .opacity(0.6)
                }
            }
            .onAppear(perform: initilization)
            .navigationTitle("Montly Steps")
            
        }
    }
    
    private func initilization() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                           updateFromStatistics(statisticsCollection)
//                            print(statisticsCollection.statistics())
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
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
