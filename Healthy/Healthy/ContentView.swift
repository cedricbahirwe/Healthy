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
            
            
            .onAppear {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
