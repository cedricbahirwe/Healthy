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
            List(steps, rowContent: StepRowView.init)
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
        // To Sort them elements from the latest
        steps.reverse()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct StepRowView: View {
    let step: Step
    var body: some View {
        HStack {
            Text("Steps: \(step.count)")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                
            Spacer()
            Text(step.date, style: .date)
                .font(.system(.body, design: .rounded))
                .foregroundColor((Color(.systemBackground)).opacity(0.8))
                .frame(width: 120, height: 30)
                .background(Color.primary)
                .cornerRadius(5)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        
    }
}
