//
//  Step.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 10/07/2021.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
