//
//  PedoMeterView.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import SwiftUI
import CoreMotion

class PedoMeterManagerStore {
    init() {
        
    }
}
struct PedoMeterView: View {
    private let pedometer:CMPedometer  = CMPedometer()
    
    @State private var distance: Double?
    @State private var steps: Int?
    private var isPedometerAvailable: Bool {
        CMPedometer.isPedometerEventTrackingAvailable() &&
            CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    var body: some View {
        NavigationView {
            VStack {
                Text("\(steps ?? 0) steps")
                    .fontWeight(.black)

                    
                Text(distance != nil ? String(format: "%.3f kilometers", distance!) : "")
                    .fontWeight(.black)

                    
            }
            .font(.system(.largeTitle, design: .rounded))
            .onAppear() {
                initializePedometer()
            }
            .navigationTitle("Past 7 days")
        }
    }
    
    
    func initializePedometer() {
        if isPedometerAvailable {
            // For the past 7 days
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            pedometer.queryPedometerData(from: startDate, to: Date()) { (pedometerData, error) in
                guard let data = pedometerData else { return }
                updateUserInterface(data: data)
            }
        }
    }
    
    private func updateUserInterface(data: CMPedometerData) {
        
        steps = data.numberOfSteps.intValue
        
        
        guard let pedometerDistance = data.distance else { return }
        
        let distanceMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        
        distance =  distanceMeters.converted(to: UnitLength.kilometers).value
    }
}

struct PedoMeterView_Previews: PreviewProvider {
    static var previews: some View {
        PedoMeterView()
    }
}
