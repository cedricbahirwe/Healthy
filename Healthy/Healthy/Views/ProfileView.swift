//
//  ProfileView.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    var healthStore: HealthStore?
    @State private var profile: Profile? = Profile.getInformation()
    @State private var weight: String = ""
    
    @State private var age: String = ""
    @State private var name: String = UIDevice.current.name
    @State private var bloodType: String = ""
    
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        Form {
            FormRowView("Name", text: $name)
                .onChange(of: name) { profile?.name = $0 }
                .disabled(true)
            FormRowView("Age", text: $age)
                .disabled(true)
            
            FormRowView("Weight", text: $weight)
            FormRowView("Blood Type", text: $bloodType)
                .disabled(true)
            
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
                    .frame(height: 40)
                    .foregroundColor(Color(.systemBackground))
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top)
        }
        .onAppear(perform: initializiation)
        .navigationTitle("Profile Settings")
    }
    
    private func initializiation()  {
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
            //                .preferredColorScheme(.dark)
        }
    }
}


