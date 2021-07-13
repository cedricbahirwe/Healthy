//
//  ProfileView.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import SwiftUI
import HealthKit
import CoreMotion


struct ProfileView: View {
    
    @AppStorage("StepCount", store: UserDefaults(suiteName: groupIdentifier))
    var stepCount: Int = 0
    
    var healthStore: HealthStore?
    var pedometerStore: PedoMeterManagerStore?
    @State private var profile: Profile? = Profile.getInformation()
    @State private var weight: String = ""
    
    @State private var age: String = ""
    @State private var name: String = UIDevice.current.name
    @State private var bloodType: String = ""
    
    @State private var distance: Double?
    @State private var steps: Int?
    
    @Environment(\.presentationMode) private var presentationMode
    
    init(healthStore: HealthStore? = nil) {
        self.healthStore = healthStore
        pedometerStore = PedoMeterManagerStore()
    }
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("Main Profile")) {
                FormRowView("Name", text: $name)
                    .onChange(of: name) { profile?.name = $0 }
                    .disabled(true)
                FormRowView("Age", text: $age)
                    .disabled(true)
                
                FormRowView("Weight", text: $weight)
                FormRowView("Blood Type", text: $bloodType)
                    .disabled(true)
            }
            
            Section(header: Text("Past 7 days Activity")) {
                HStack {
                    Text("Steps:")
                    if let steps = steps {
                        Text("\(steps)")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                
                HStack {
                    Text("Distance:")
                    if let distance = distance {
                        Text(String(format: "%.2f kilometers", distance))
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
            }
            
            
            Button(action: {
                guard let weight = Double(weight) else { return }
                healthStore!.saveBodyMass(weight: weight) {
                    if $0 {
                        profile!.saveInformation()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Failed to save the weight")
                    }
                }
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .foregroundColor(Color(.systemBackground))
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical)
        }
        .onAppear {
            initializiationHealthKit()
            initializePedometer()
        }
        .navigationTitle("Profile Settings")
        }
    }
    
    private func initializiationHealthKit()  {
        guard let healthStore = healthStore else { return }
        healthStore.getBodyMass { mass in
            var result = mass
            result.removeAll(where: { $0.isLetter })
            result = result.replacingOccurrences(of: " ", with: "")
                
            weight = result
            
            
            let resultInfo = healthStore.getInfo()
            profile?.age = resultInfo.age ?? 0
            
            let type = resultInfo.bloodType!.readableBloodType()
            
            bloodType = type
            if let age = resultInfo.age {
                self.age = String(age)
            }
            
            profile = Profile(name: UIDevice.current.name,
                              age: resultInfo.age ?? 0,
                              weight: Double(result) ?? 0,
                              bloodType: resultInfo.bloodType!.readableBloodType())
        }
    }
    
    
    private func initializePedometer() {
        if let pedometerStore = pedometerStore {
            pedometerStore.initializePedometer(completion: updateUserInterface)
        }
    }
    
    private func updateUserInterface(data: CMPedometerData) {
        
        steps = data.numberOfSteps.intValue
        stepCount = data.numberOfSteps.intValue
        
        guard let pedometerDistance = data.distance else { return }
        
        let distanceMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        
        distance =  distanceMeters.converted(to: UnitLength.kilometers).value
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
            //                .preferredColorScheme(.dark)
        }
    }
}


