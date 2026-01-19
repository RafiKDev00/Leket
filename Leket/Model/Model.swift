//
//  Model.swift
//  Leket
//
//  Created by RJ  Kigner on 1/14/26.
//

import SwiftUI
import MapKit

// MARK: - Date Extension

extension Date {
    var dayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    static func from(dayKey: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dayKey)
    }
}

// MARK: - Core domain types

struct Farmer: Identifiable, Hashable {
    let id: String
    let name: String
    let email: String
    let phone: String
}

struct Volunteer: Identifiable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String

    var fullName: String { "\(firstName) \(lastName)" }
}

struct DateRange: Hashable {
    let start: Date
    let end: Date

    func contains(_ date: Date) -> Bool {
        start <= date && date <= end
    }
}

enum SignupStatus: String, Hashable {
    case upcoming
    case active
    case completed
}

struct VolunteerSignup: Identifiable, Hashable {
    let id: String
    let volunteer: Volunteer
    let farmID: String
    let range: DateRange
    let status: SignupStatus
}

struct FarmDay: Identifiable, Hashable {
    let id: String              // "farm-id_2026-01-20" format
    let date: Date
    var isOpen: Bool            // Can volunteers sign up?
    var volunteersNeeded: Int
    var tasks: [String]
    var signups: [VolunteerSignup]

    var signupCount: Int { signups.count }
    var spotsRemaining: Int { max(0, volunteersNeeded - signupCount) }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: FarmDay, rhs: FarmDay) -> Bool { lhs.id == rhs.id }
}

struct Farm: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let volunteersNeeded: Int
    let tasks: [String]
    let farmer: Farmer
    let availability: [DateRange]          // Windows when the farm is accepting volunteers
    let signups: [VolunteerSignup]         // Who signed up and when
    let imageName: String                  // Asset image name for the farm
    var isPublic: Bool                     // Visible to volunteers?
    var days: [String: FarmDay]            // Dictionary keyed by date string "yyyy-MM-dd"

    // Helper for MapKit
    var location: CLLocationCoordinate2D { coordinate }

    // Derived helpers
    func isAcceptingVolunteers(on date: Date = Date()) -> Bool {
        if let day = days[date.dayKey] {
            return day.isOpen && day.spotsRemaining > 0
        }
        return availability.contains { $0.contains(date) }
    }

    func volunteers(on date: Date = Date()) -> [VolunteerSignup] {
        if let day = days[date.dayKey] {
            return day.signups
        }
        return signups.filter { $0.range.contains(date) }
    }

    // Total signups across all days
    var totalDaySignups: Int {
        days.values.reduce(0) { $0 + $1.signupCount }
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Farm, rhs: Farm) -> Bool { lhs.id == rhs.id }
}

// MARK: - Sample data

private enum SampleData {
    static let farmers: [Farmer] = [
        Farmer(id: "farmer-1", name: "Yael Cohen", email: "yael@galilee-grove.il", phone: "+972-54-111-0001"),
        Farmer(id: "farmer-2", name: "Avi Ben-David", email: "avi@negev-fields.il", phone: "+972-52-222-0002"),
        Farmer(id: "farmer-3", name: "Maya Levi", email: "maya@jerusalem-vines.il", phone: "+972-50-333-0003")
    ]

    static let volunteers: [Volunteer] = [
        Volunteer(id: "vol-1", firstName: "Daniel", lastName: "Levy", email: "daniel@example.com", phone: "+1-212-555-1001"),
        Volunteer(id: "vol-2", firstName: "Sara", lastName: "Green", email: "sara@example.com", phone: "+44-20-555-2002"),
        Volunteer(id: "vol-3", firstName: "Noa", lastName: "Kaplan", email: "noa@example.com", phone: "+972-58-555-3003")
    ]

    static func range(daysFromNow start: Int, length days: Int) -> DateRange {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: start, to: Date()) ?? Date()
        let endDate = calendar.date(byAdding: .day, value: start + days, to: Date()) ?? Date()
        return DateRange(start: startDate, end: endDate)
    }

    static let signups: [VolunteerSignup] = [
        VolunteerSignup(
            id: "signup-1",
            volunteer: volunteers[0],
            farmID: "farm-jerusalem",
            range: range(daysFromNow: -5, length: 5),
            status: .completed
        ),
        VolunteerSignup(
            id: "signup-2",
            volunteer: volunteers[1],
            farmID: "farm-galilee",
            range: range(daysFromNow: 3, length: 4),
            status: .upcoming
        ),
        VolunteerSignup(
            id: "signup-3",
            volunteer: volunteers[2],
            farmID: "farm-negev",
            range: range(daysFromNow: 0, length: 7),
            status: .active
        )
    ]
}

extension Farmer {
    static let sampleFarmers = SampleData.farmers
}

extension Volunteer {
    static let sampleVolunteers = SampleData.volunteers
}

extension Farm {
    static let sampleFarms: [Farm] = [
        Farm(
            id: "farm-galilee",
            name: "Galilee Grove",
            description: "Olive and citrus orchard in the Upper Galilee.",
            coordinate: CLLocationCoordinate2D(latitude: 32.992, longitude: 35.497),
            volunteersNeeded: 12,
            tasks: ["Harvest citrus", "Prune olives", "Irrigation checks"],
            farmer: SampleData.farmers[0],
            availability: [
                SampleData.range(daysFromNow: -2, length: 14),
                SampleData.range(daysFromNow: 30, length: 10)
            ],
            signups: SampleData.signups.filter { $0.farmID == "farm-galilee" },
            imageName: "IMG_8127",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-negev",
            name: "Negev Fields",
            description: "Date palms and vegetables near Be'er Sheva.",
            coordinate: CLLocationCoordinate2D(latitude: 31.245, longitude: 34.791),
            volunteersNeeded: 8,
            tasks: ["Pick dates", "Weed beds", "Pack produce"],
            farmer: SampleData.farmers[1],
            availability: [
                SampleData.range(daysFromNow: -1, length: 21)
            ],
            signups: SampleData.signups.filter { $0.farmID == "farm-negev" },
            imageName: "IMG_0209",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-sharon",
            name: "Sharon Coastal Farm",
            description: "Strawberries and avocados by Netanya.",
            coordinate: CLLocationCoordinate2D(latitude: 32.321, longitude: 34.853),
            volunteersNeeded: 10,
            tasks: ["Harvest berries", "Sort avocados", "Greenhouse upkeep"],
            farmer: SampleData.farmers[0],
            availability: [
                SampleData.range(daysFromNow: 5, length: 12)
            ],
            signups: [],
            imageName: "IMG_7782",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-golan",
            name: "Golan Heights Orchard",
            description: "Apples and cherries overlooking the Kinneret.",
            coordinate: CLLocationCoordinate2D(latitude: 33.042, longitude: 35.702),
            volunteersNeeded: 6,
            tasks: ["Pick apples", "Sort cherries", "Crate loading"],
            farmer: SampleData.farmers[0],
            availability: [
                SampleData.range(daysFromNow: 20, length: 7)
            ],
            signups: [],
            imageName: "IMG_5002",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-jerusalem",
            name: "Jerusalem Hills Vineyard",
            description: "Grapes and figs in the Judean Hills.",
            coordinate: CLLocationCoordinate2D(latitude: 31.769, longitude: 35.153),
            volunteersNeeded: 9,
            tasks: ["Harvest grapes", "Trellis maintenance", "Clean tools"],
            farmer: SampleData.farmers[2],
            availability: [
                SampleData.range(daysFromNow: -10, length: 5),
                SampleData.range(daysFromNow: 15, length: 10)
            ],
            signups: SampleData.signups.filter { $0.farmID == "farm-jerusalem" },
            imageName: "IMG_6409",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-haifa",
            name: "Haifa Bay Greenhouse",
            description: "Tomatoes and peppers in coastal greenhouses.",
            coordinate: CLLocationCoordinate2D(latitude: 32.836, longitude: 35.006),
            volunteersNeeded: 7,
            tasks: ["Pick tomatoes", "Stake peppers", "Pack crates"],
            farmer: SampleData.farmers[0],
            availability: [
                SampleData.range(daysFromNow: 2, length: 18)
            ],
            signups: [],
            imageName: "IMG_8127",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-jordan",
            name: "Jordan Valley Dates",
            description: "Date palms along the Jordan Valley.",
            coordinate: CLLocationCoordinate2D(latitude: 32.262, longitude: 35.566),
            volunteersNeeded: 11,
            tasks: ["Thin clusters", "Collect dates", "Irrigation checks"],
            farmer: SampleData.farmers[1],
            availability: [
                SampleData.range(daysFromNow: -3, length: 30)
            ],
            signups: [],
            imageName: "IMG_1086",
            isPublic: true,
            days: [:]
        ),
        Farm(
            id: "farm-eilat",
            name: "Eilat Desert Plots",
            description: "Desert vegetables near Eilat.",
            coordinate: CLLocationCoordinate2D(latitude: 29.557, longitude: 34.951),
            volunteersNeeded: 5,
            tasks: ["Harvest greens", "Mulch beds", "Repair drip lines"],
            farmer: SampleData.farmers[2],
            availability: [
                SampleData.range(daysFromNow: 7, length: 14)
            ],
            signups: [],
            imageName: "IMG_4985",
            isPublic: true,
            days: [:]
        )
    ]
}
