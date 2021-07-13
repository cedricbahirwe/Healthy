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
    @State private var profile: Profile?
    @State private var weight: String = ""
    var body: some View {
        Form {
            
            FormRowView("Name", text: .constant(""))
            
            FormRowView("Age", text: .constant(""))
            
            FormRowView("Weight", text: $weight)
            FormRowView("Blood Type", text: .constant(""))
            
            Button(action: {
                guard let weight = Double(weight) else { return }
                healthStore!.saveBodyMass(weight: weight) {
                    print($0)
                }
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundColor(Color(.systemBackground))
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .navigationTitle("Profile Settings")
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
