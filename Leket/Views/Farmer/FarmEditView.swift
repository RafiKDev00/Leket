//
//  FarmEditView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

struct FarmEditView: View {
    let farm: Farm
    let onSave: (Farm) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var description: String
    @State private var volunteersNeeded: Int
    @State private var tasksText: String

    init(farm: Farm, onSave: @escaping (Farm) -> Void) {
        self.farm = farm
        self.onSave = onSave
        _name = State(initialValue: farm.name)
        _description = State(initialValue: farm.description)
        _volunteersNeeded = State(initialValue: farm.volunteersNeeded)
        _tasksText = State(initialValue: farm.tasks.joined(separator: "\n"))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Farm Name", text: $name)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }

                Section("Volunteers") {
                    Stepper("Volunteers Needed: \(volunteersNeeded)", value: $volunteersNeeded, in: 1...50)
                }

                Section("Tasks (one per line)") {
                    TextEditor(text: $tasksText)
                        .frame(minHeight: 100)
                        .padding(8)
                }

                Section {
                    HStack {
                        Image(farm.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.gray.opacity(0.3), radius: 4)

                        VStack(alignment: .leading) {
                            Text("Current Image")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(farm.imageName)
                                .font(.caption2)
                        }
                    }
                } header: {
                    Text("Farm Image")
                }
            }
            .navigationTitle("Edit Farm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("BattleshipGray"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.glassProminent)
                    .tint(Color("Highland"))
                }
            }
        }
    }

    private func saveChanges() {
        let tasks = tasksText
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let updatedFarm = Farm(
            id: farm.id,
            name: name,
            description: description,
            coordinate: farm.coordinate,
            volunteersNeeded: volunteersNeeded,
            tasks: tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups,
            imageName: farm.imageName,
            isPublic: farm.isPublic,
            days: farm.days
        )

        onSave(updatedFarm)
    }
}

#Preview {
    FarmEditView(farm: Farm.sampleFarms[0]) { _ in }
}
