//
//  Profile.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import Foundation

struct Profile: Codable {
    var name: String = ""
    var age: Int
    var weight: Double
    var bloodType: String = ""
    
    static let identifier = "UserProfile"
}


extension Profile {
    static func getInformation() -> Profile? {
        var profile: Profile?
        
        do {
            guard let data = UserDefaults.standard.object(forKey: identifier) as? Data
            else { return nil }
            let response = try! JSONDecoder().decode(Profile.self, from: data)
            profile = response
        }
        
        return profile
    }
    
    public func saveInformation() {
        do {
            guard let data = try? JSONEncoder().encode(self) else { return }
            UserDefaults.standard.set(data, forKey: Self.identifier)
        }
    }
}
