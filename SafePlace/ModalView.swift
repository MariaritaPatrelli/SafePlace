//
//  ModalView.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 17/12/24.
//
//import SwiftUI
//import MapKit
//
//struct ModalView: View {
//    @Binding var showModal: Bool
//    @Binding var searchQuery: String
//    var selectedStation: MKMapItem?
//    var onCall: () -> Void
//    var onVideoCall: () -> Void
//    var onChat: () -> Void
//    var onSearch: () -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text("Police Stations")
//                    .font(.title)
//                    .bold()
//                    .padding(.horizontal)
//                
//                Spacer()
//                
//                HStack(spacing: 16) {
//                    CircularButton(systemImage: "phone.fill", color: .red, action: onCall)
//                    CircularButton(systemImage: "video.fill", color: .blue, action: onVideoCall)
//                    CircularButton(systemImage: "message.fill", color: .green, action: onChat)
//                }
//                .padding(.trailing)
//            }
//            
//            HStack {
//                TextField("Enter City Name...", text: $searchQuery)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                    .onTapGesture {
//                        showModal = true // Set to true when the search bar is tapped
//                    }
//                Button(action: onSearch) {
//                    Image(systemName: "magnifyingglass")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                }
//            }
//
//            // Show information of the selected station
//            if let station = selectedStation {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Name: \(station.name ?? "N/A")")
//                        .font(.headline)
//                    Text("Address: \(station.placemark.title ?? "N/A")")
//                        .font(.subheadline)
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .padding(.horizontal)
//            } else {
//                Text("Select a station to view details.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//            }
//            
//            Spacer()
//        }
//        .padding(.top)
//    }
//}
import SwiftUI
import MapKit

struct ModalView: View {
    @Binding var searchQuery: String
    var selectedStation: MKMapItem?
    var distanceToStation: Double? // Distance to selected station
    var route: MKRoute? // Route to be displayed
    var onCall: () -> Void
    var onVideoCall: () -> Void
    var onChat: () -> Void
    var onSearch: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Police Stations")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 16) {
                    CircularButton(systemImage: "phone.fill", color: .red, action: onCall)
                    CircularButton(systemImage: "video.fill", color: .blue, action: onVideoCall)
                    CircularButton(systemImage: "message.fill", color: .green, action: onChat)
                }
                .padding(.trailing)
            }
            HStack {
                TextField("Enter City Name...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        
            if let station = selectedStation {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(station.name ?? "N/A")")
                        .font(.headline)
                    Text("Address: \(station.placemark.title ?? "N/A")")
                        .font(.subheadline)
                    if let distance = distanceToStation {
                        Text("Distance: \(String(format: "%.2f", distance)) km")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            } else {
                Text("Select a station to view details.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            // Show route details if route exists
            if let route = route {
                VStack {
                    Text("Route:")
                        .font(.headline)
                        .padding(.top)
                    Text("Estimated travel time: \(String(format: "%.0f", route.expectedTravelTime / 60)) minutes")
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
    }
}



struct CircularButton: View {
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .background(color)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}
