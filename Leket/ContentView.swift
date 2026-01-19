//
//  ContentView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/13/26.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(AppSession.self) private var session

    var body: some View {
        switch session.authState {
        case .unauthenticated:
            EntryPortalView()

        case .onboarding:
            if session.userType == .volunteer {
                VolunteerOnboardingView()
            } else {
                FarmerOnboardingView()
            }

        case .authenticated:
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @Environment(AppSession.self) private var session

    // Volunteers see only public farms, farmers see all farms
    private var visibleFarms: [Farm] {
        session.userType == .volunteer ? session.publicFarms : session.farms
    }

    var body: some View {
        TabView {
            FarmMapView(farms: visibleFarms)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            FarmListView(farms: visibleFarms)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct ProfileTabView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        if session.userType == .volunteer {
            VolunteerProfileView()
        } else {
            FarmerDashboardView()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environment(AppSession())
}


// - Volunteers: daniel@example.com, sara@example.com
// - Farmers: yael@galilee-grove.il, avi@negev-fields.il               
