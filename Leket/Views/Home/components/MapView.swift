//
//  MapView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/13/26.
//

import SwiftUI
import MapKit

struct FarmMapView: View {
    @State private var selectedFarm: Farm?
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 31.5, longitude: 35.0),
            span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        )
    )

    let farms: [Farm]

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedFarm) {
            ForEach(farms) { farm in
                // Native label: farm.name is managed by Map/Annotation; content is just the pin artwork
                Annotation(farm.name, coordinate: farm.coordinate) {
                    FarmMapMarker(farm: farm)
                }
                .tag(farm as Farm?)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }
}

#Preview("Farm Map") {
    FarmMapView(farms: Farm.sampleFarms)
}
