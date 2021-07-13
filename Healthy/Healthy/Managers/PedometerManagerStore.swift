//
//  PedometerManagerStore.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import CoreMotion

class PedoMeterManagerStore {
    
    var pedometer: CMPedometer?
    
    private var isPedometerAvailable: Bool {
        CMPedometer.isPedometerEventTrackingAvailable() &&
            CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    init() {
        
        if isPedometerAvailable {
            pedometer = CMPedometer()
        }
    }
    
    
    func initializePedometer(completion: @escaping(CMPedometerData) -> Void) {
        
        if let pedometer  = pedometer {
            // For the past 7 days
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            pedometer.queryPedometerData(from: startDate, to: Date()) { (pedometerData, error) in
                guard let data = pedometerData else { return }
                completion(data)
            }
        }
    }
}
