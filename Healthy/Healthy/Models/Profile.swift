//
//  Profile.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import Foundation

struct Profile: Identifiable {
    var id: String { name }
    var name: String = ""
    var age: Int
    var weight: Double
    var bloodType: String = ""
}
