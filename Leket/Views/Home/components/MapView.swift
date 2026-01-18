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
        Map(position: $cameraPosition) {
            ForEach(farms) { farm in
                Annotation(farm.name, coordinate: farm.coordinate) {
                    markerView(for: farm)
                }
                .annotationTitles(.hidden)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }

    @ViewBuilder
    private func markerView(for farm: Farm) -> some View {
        let isSelected = selectedFarm?.id == farm.id

        FarmMapMarker(farm: farm, isSelected: isSelected)
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    if isSelected {
                        selectedFarm = nil
                    } else {
                        selectedFarm = farm
                    }
                }
            }
    }
}

#Preview("Farm Map") {
    FarmMapView(farms: Farm.sampleFarms)
}
