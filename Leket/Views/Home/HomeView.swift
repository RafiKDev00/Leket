//
//  HomeView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/13/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        FarmMapView(farms: Farm.sampleFarms)
    }
}

#Preview {
    HomeView()
}
