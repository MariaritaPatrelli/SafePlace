//
//  UtilityFunction.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 17/12/24.
//
import MapKit
import Foundation
import Contacts
import UIKit

// Function to find a city using the MKLocalSearch API
func findCity(named cityName: String) async -> MKMapItem? {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = cityName
    request.addressFilter = MKAddressFilter(including: .locality)
    let search = MKLocalSearch(request: request)
    let response = try? await search.start()
    return response?.mapItems.first
}

// Function to find police stations near a city
func findPoliceStations(in city: MKMapItem) async -> [MKMapItem] {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = "police"
    let region = MKCoordinateRegion(
        center: city.placemark.coordinate,
        span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )
    request.region = region
    
    let search = MKLocalSearch(request: request)
    let response = try? await search.start()
    return response?.mapItems ?? []
}


func callEmergency() {
    print("Calling 112...")
    if let url = URL(string: "tel://\(3471363018)") {
        UIApplication.shared.open(url)
    }
}


//func startVideoCall() {
//    print("Starting video call...")
//}

func startChat() {
    print("Opening chat...")
}

//func VideoCall() {
//    print("Starting video call...")
//    
//    // Get the emergency contact phone number
//    if let emergencyContactPhone = getEmergencyContactPhoneNumber() {
//        if let url = URL(string: "facetime://\(emergencyContactPhone)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url) // Open FaceTime with the contact
//            } else {
//                print("Cannot make a FaceTime video call on this device.")
//            }
//        }
//    } else {
//        print("No emergency contact found.")
//    }
//}
//
//// Function to retrieve the emergency contact's phone number from the user's contacts
//private func getEmergencyContactPhoneNumber() -> String? {
//    let store = CNContactStore()
//
//    // Use CNKeyDescriptor for proper key fetching
//    let keysToFetch: [CNKeyDescriptor] = [CNContactPhoneNumbersKey as CNKeyDescriptor]
//
//    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
//
//    var emergencyContactPhoneNumber: String?
//    do {
//        try store.enumerateContacts(with: request) { (contact, stop) in
//            // Fetch the first phone number
//            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
//                emergencyContactPhoneNumber = phoneNumber
//                stop.pointee = true // Stop after finding the first contact
//            }
//        }
//    } catch {
//        print("Failed to fetch contacts: \(error)")
//    }
//
//    return emergencyContactPhoneNumber
//}
func VideoCall() {
    print("Starting video call...")
    
    // Get a randomly selected emergency contact phone number
    if let emergencyContactPhone = getRandomEmergencyContactPhoneNumber() {
        if let url = URL(string: "facetime://\(emergencyContactPhone)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) // Open FaceTime with the contact
            } else {
                print("Cannot make a FaceTime video call on this device.")
            }
        }
    } else {
        print("No emergency contact found.")
    }
}

// Function to retrieve a random emergency contact's phone number from the user's contacts
private func getRandomEmergencyContactPhoneNumber() -> String? {
    let store = CNContactStore()
    
    // Use CNKeyDescriptor for proper key fetching
    let keysToFetch: [CNKeyDescriptor] = [CNContactPhoneNumbersKey as CNKeyDescriptor]
    
    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
    
    var emergencyContacts: [String] = [] // Array to store phone numbers
    
    do {
        try store.enumerateContacts(with: request) { (contact, stop) in
            // Add phone number to the list of emergency contacts
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                emergencyContacts.append(phoneNumber)
            }
        }
    } catch {
        print("Failed to fetch contacts: \(error)")
    }
    
    // If we have any emergency contacts, select one randomly
    if !emergencyContacts.isEmpty {
        let randomIndex = Int.random(in: 0..<emergencyContacts.count)
        return emergencyContacts[randomIndex]
    }
    
    return nil // Return nil if no emergency contacts are found
}
