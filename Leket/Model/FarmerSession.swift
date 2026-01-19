//
//  FarmerSession.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

@Observable
class FarmerSession {
    var currentFarmer: Farmer?
    var farms: [Farm]

    var isLoggedIn: Bool {
        currentFarmer != nil
    }

    var myFarms: [Farm] {
        guard let farmer = currentFarmer else { return [] }
        return farms.filter { $0.farmer.id == farmer.id }
    }

    init() {
        self.farms = Farm.sampleFarms
    }

    func login(as farmer: Farmer) {
        currentFarmer = farmer
    }

    func logout() {
        currentFarmer = nil
    }

    func updateFarm(_ farm: Farm) {
        if let index = farms.firstIndex(where: { $0.id == farm.id }) {
            farms[index] = farm
        }
    }
}
