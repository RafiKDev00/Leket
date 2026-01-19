//
//  AppSession.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI
import MapKit

enum UserType: String, Codable {
    case volunteer
    case farmer
}

enum AuthState {
    case unauthenticated
    case onboarding
    case authenticated
}

@Observable
class AppSession {
    var authState: AuthState = .unauthenticated
    var userType: UserType?

    // Current users
    var currentVolunteer: Volunteer?
    var currentFarmer: Farmer?

    // App data
    var farms: [Farm]
    var volunteers: [Volunteer]

    var isLoggedIn: Bool {
        authState == .authenticated
    }

    // For farmers - their farms
    var myFarms: [Farm] {
        guard let farmer = currentFarmer else { return [] }
        return farms.filter { $0.farmer.id == farmer.id }
    }

    init() {
        self.farms = Farm.sampleFarms
        self.volunteers = Volunteer.sampleVolunteers
    }

    // MARK: - Auth Methods

    func signIn(email: String, as type: UserType) -> Bool {
        userType = type

        if type == .volunteer {
            if let volunteer = volunteers.first(where: { $0.email.lowercased() == email.lowercased() }) {
                currentVolunteer = volunteer
                authState = .authenticated
                return true
            }
        } else {
            if let farmer = Farmer.sampleFarmers.first(where: { $0.email.lowercased() == email.lowercased() }) {
                currentFarmer = farmer
                authState = .authenticated
                return true
            }
        }
        return false
    }

    func signIn(phone: String, as type: UserType) -> Bool {
        userType = type

        if type == .volunteer {
            if let volunteer = volunteers.first(where: { $0.phone == phone }) {
                currentVolunteer = volunteer
                authState = .authenticated
                return true
            }
        } else {
            if let farmer = Farmer.sampleFarmers.first(where: { $0.phone == phone }) {
                currentFarmer = farmer
                authState = .authenticated
                return true
            }
        }
        return false
    }

    func startOnboarding(as type: UserType) {
        userType = type
        authState = .onboarding
    }

    func completeVolunteerOnboarding(firstName: String, lastName: String, email: String, phone: String) {
        let newVolunteer = Volunteer(
            id: UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone
        )
        volunteers.append(newVolunteer)
        currentVolunteer = newVolunteer
        authState = .authenticated
    }

    func completeFarmerOnboarding(name: String, email: String, phone: String) {
        let newFarmer = Farmer(
            id: UUID().uuidString,
            name: name,
            email: email,
            phone: phone
        )
        currentFarmer = newFarmer
        authState = .authenticated
    }

    func updateVolunteer(_ volunteer: Volunteer) {
        if let index = volunteers.firstIndex(where: { $0.id == volunteer.id }) {
            volunteers[index] = volunteer
        }
        if currentVolunteer?.id == volunteer.id {
            currentVolunteer = volunteer
        }
    }

    func updateFarm(_ farm: Farm) {
        if let index = farms.firstIndex(where: { $0.id == farm.id }) {
            farms[index] = farm
        }
    }

    func signUpForFarm(_ farm: Farm) {
        guard let volunteer = currentVolunteer else { return }
        guard let farmIndex = farms.firstIndex(where: { $0.id == farm.id }) else { return }

        let signup = VolunteerSignup(
            id: UUID().uuidString,
            volunteer: volunteer,
            farmID: farm.id,
            range: DateRange(start: Date(), end: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()),
            status: .upcoming
        )

        // Create updated farm with new signup
        let updatedFarm = Farm(
            id: farm.id,
            name: farm.name,
            description: farm.description,
            coordinate: farm.coordinate,
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups + [signup],
            imageName: farm.imageName,
            isPublic: farm.isPublic,
            days: farm.days
        )

        farms[farmIndex] = updatedFarm
    }

    func hasSignedUp(for farm: Farm) -> Bool {
        guard let volunteer = currentVolunteer else { return false }
        return farm.signups.contains { $0.volunteer.id == volunteer.id }
    }

    // MARK: - Calendar Methods

    /// Get farms visible to volunteers (filters by isPublic)
    var publicFarms: [Farm] {
        farms.filter { $0.isPublic }
    }

    /// Get or create a FarmDay for a specific date
    func getFarmDay(for farm: Farm, on date: Date) -> FarmDay {
        let dayKey = date.dayKey
        if let existingDay = farm.days[dayKey] {
            return existingDay
        }
        // Create a default day based on farm defaults
        return FarmDay(
            id: "\(farm.id)_\(dayKey)",
            date: date,
            isOpen: farm.isAcceptingVolunteers(on: date),
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            signups: []
        )
    }

    /// Update a specific day's configuration
    func updateFarmDay(_ day: FarmDay, for farm: Farm) {
        guard let farmIndex = farms.firstIndex(where: { $0.id == farm.id }) else { return }
        var updatedDays = farms[farmIndex].days
        updatedDays[day.date.dayKey] = day

        let updatedFarm = Farm(
            id: farm.id,
            name: farm.name,
            description: farm.description,
            coordinate: farm.coordinate,
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups,
            imageName: farm.imageName,
            isPublic: farm.isPublic,
            days: updatedDays
        )
        farms[farmIndex] = updatedFarm
    }

    /// Volunteer signs up for a specific day
    func signUpForDay(farm: Farm, date: Date) {
        guard let volunteer = currentVolunteer else { return }
        guard let farmIndex = farms.firstIndex(where: { $0.id == farm.id }) else { return }

        let dayKey = date.dayKey
        var farmDay = getFarmDay(for: farm, on: date)

        // Check if already signed up
        guard !farmDay.signups.contains(where: { $0.volunteer.id == volunteer.id }) else { return }

        let signup = VolunteerSignup(
            id: UUID().uuidString,
            volunteer: volunteer,
            farmID: farm.id,
            range: DateRange(start: date, end: date),
            status: .upcoming
        )

        farmDay.signups.append(signup)

        var updatedDays = farms[farmIndex].days
        updatedDays[dayKey] = farmDay

        let updatedFarm = Farm(
            id: farm.id,
            name: farm.name,
            description: farm.description,
            coordinate: farm.coordinate,
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups,
            imageName: farm.imageName,
            isPublic: farm.isPublic,
            days: updatedDays
        )
        farms[farmIndex] = updatedFarm
    }

    /// Check if volunteer is signed up for a specific day
    func isSignedUp(for farm: Farm, on date: Date) -> Bool {
        guard let volunteer = currentVolunteer else { return false }
        let farmDay = getFarmDay(for: farm, on: date)
        return farmDay.signups.contains { $0.volunteer.id == volunteer.id }
    }

    /// Volunteer cancels signup for a specific day
    func unsignFromDay(farm: Farm, date: Date) {
        guard let volunteer = currentVolunteer else { return }
        guard let farmIndex = farms.firstIndex(where: { $0.id == farm.id }) else { return }

        let dayKey = date.dayKey
        var farmDay = getFarmDay(for: farm, on: date)

        // Remove the volunteer's signup
        farmDay.signups.removeAll { $0.volunteer.id == volunteer.id }

        var updatedDays = farms[farmIndex].days
        updatedDays[dayKey] = farmDay

        let updatedFarm = Farm(
            id: farm.id,
            name: farm.name,
            description: farm.description,
            coordinate: farm.coordinate,
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups,
            imageName: farm.imageName,
            isPublic: farm.isPublic,
            days: updatedDays
        )
        farms[farmIndex] = updatedFarm
    }

    /// Get all day signups for current volunteer
    var myDaySignups: [(farm: Farm, date: Date, signup: VolunteerSignup)] {
        guard let volunteer = currentVolunteer else { return [] }
        var results: [(farm: Farm, date: Date, signup: VolunteerSignup)] = []

        for farm in farms {
            for (dayKey, farmDay) in farm.days {
                for signup in farmDay.signups where signup.volunteer.id == volunteer.id {
                    if let date = Date.from(dayKey: dayKey) {
                        results.append((farm: farm, date: date, signup: signup))
                    }
                }
            }
        }

        return results.sorted { $0.date < $1.date }
    }

    /// Check if volunteer has any signup for a farm (any day)
    func hasAnySignup(for farm: Farm) -> Bool {
        guard let volunteer = currentVolunteer else { return false }
        for (_, farmDay) in farm.days {
            if farmDay.signups.contains(where: { $0.volunteer.id == volunteer.id }) {
                return true
            }
        }
        return false
    }

    /// Toggle farm visibility
    func toggleFarmVisibility(_ farm: Farm) {
        guard let farmIndex = farms.firstIndex(where: { $0.id == farm.id }) else { return }

        let updatedFarm = Farm(
            id: farm.id,
            name: farm.name,
            description: farm.description,
            coordinate: farm.coordinate,
            volunteersNeeded: farm.volunteersNeeded,
            tasks: farm.tasks,
            farmer: farm.farmer,
            availability: farm.availability,
            signups: farm.signups,
            imageName: farm.imageName,
            isPublic: !farm.isPublic,
            days: farm.days
        )
        farms[farmIndex] = updatedFarm
    }

    func logout() {
        authState = .unauthenticated
        userType = nil
        currentVolunteer = nil
        currentFarmer = nil
    }
}
