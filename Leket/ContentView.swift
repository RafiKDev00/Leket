//
//  ContentView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/13/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView{
            FarmMapView(farms: Farm.sampleFarms)
                .tabItem{
                    Label("Map", systemImage: "map.fill")
            }
            FarmListView(farms: Farm.sampleFarms)
                .tabItem{
                    Label("list", systemImage: "list.fill")
            }
            
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
