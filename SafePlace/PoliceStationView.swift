//
//  PoliceStationView.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 16/12/24.
//
//import SwiftUI
//import MapKit
//
//struct PoliceStationView: View {
//    @State private var position: MapCameraPosition = .automatic
//    @State private var policestations: [MKMapItem] = []
//    @State private var searchQuery: String = ""
//    @State private var selectedStation: MKMapItem? // Stato per la stazione selezionata
//
//    // Stati per gli alert
//    @State private var showAlert: Bool = false
//    @State private var currentAction: (() -> Void)? // Azione da eseguire dopo la conferma
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            // Mappa con selezione
//            Map(position: $position, selection: $selectedStation) {
//                ForEach(policestations, id: \.self) { police in
//                    Marker(item: police)
//                        .tag(police) // Collega il marker all'elemento
//                }
//            }
//            .task {
//                guard let naples = await findCity() else { return }
//                policestations = await findPoliceStations(in: naples)
//            }
//            
//            // Modale sempre visibile
//            BottomSheet {
//                ModalView(
//                    searchQuery: $searchQuery,
//                    selectedStation: selectedStation,
//                    onCall: { confirmAction(callEmergency) },
//                    onVideoCall: { confirmAction(startVideoCall) },
//                    onChat: { confirmAction(startChat) }
//                )
//            }
//            .frame(maxHeight: UIScreen.main.bounds.height * 0.4) // Limita l'altezza della modale
//        }
//        .edgesIgnoringSafeArea(.all) // Per estendere la mappa sotto la modale
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text("Are you sure?"),
//                message: Text("This action cannot be undone."),
//                primaryButton: .default(Text("Yes"), action: {
//                    currentAction?()
//                }),
//                secondaryButton: .cancel()
//            )
//        }
//    }
//
//    // Conferma azione con alert
//    private func confirmAction(_ action: @escaping () -> Void) {
//        currentAction = action
//        showAlert = true
//    }
//}
//
//// BottomSheet personalizzato
////struct BottomSheet<Content: View>: View {
////    let content: Content
////
////    init(@ViewBuilder content: () -> Content) {
////        self.content = content()
////    }
////
////    var body: some View {
////        VStack(spacing: 0) {
////            Capsule()
////                .fill(Color.gray)
////                .frame(width: 40, height: 6)
////                .padding(.top, 8)
////            
////            content
////                .background(Color.white)
////                .cornerRadius(16)
////                .shadow(radius: 10)
////        }
////        .background(Color.white.opacity(0.8))
////    }
////}
//
//// BottomSheet personalizzato con movimento
//struct BottomSheet<Content: View>: View {
//    let content: Content
//    @GestureState private var dragOffset = CGSize.zero
//    @State private var currentOffsetY: CGFloat = UIScreen.main.bounds.height * 0.1 // Centra all'inizio
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Capsule()
//                .fill(Color.gray)
//                .frame(width: 40, height: 6)
//                .padding(.top, 8)
//
//            content
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(radius: 10)
//        }
//        .background(Color.white.opacity(0.8))
//        .offset(y: currentOffsetY + dragOffset.height)
//        .gesture(
//            DragGesture()
//                .updating($dragOffset) { value, state, _ in
//                    state = value.translation
//                }
//                .onEnded { value in
//                    // Adjust the modal position based on the drag
//                    let maxHeight = UIScreen.main.bounds.height * 0.4
//                    let minHeight: CGFloat = 50
//
//                    if currentOffsetY + value.translation.height > maxHeight {
//                        currentOffsetY = maxHeight
//                    } else if currentOffsetY + value.translation.height < minHeight {
//                        currentOffsetY = minHeight
//                    } else {
//                        currentOffsetY += value.translation.height
//                    }
//                }
//        )
//    }
//}
//
//
//// ModalView con titolo, barra di ricerca, informazioni e pulsanti
//struct ModalView: View {
//    @Binding var searchQuery: String
//    var selectedStation: MKMapItem?
//    var onCall: () -> Void
//    var onVideoCall: () -> Void
//    var onChat: () -> Void
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
//            TextField("Search..", text: $searchQuery)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//            
//            // Mostra informazioni della stazione selezionata
//            if let station = selectedStation {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Name: \(station.name ?? "N/A")")
//                        .font(.headline)
//                    Text("Address: \(station.placemark.title ?? "N/A")")
//                        .font(.subheadline)
//                    Text("Coordinates: \(station.placemark.coordinate.latitude), \(station.placemark.coordinate.longitude)")
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
//            Spacer() // Per lasciare spazio sotto
//        }
//        .padding(.top)
//    }
//}
//
//// Pulsante circolare personalizzato
//struct CircularButton: View {
//    let systemImage: String
//    let color: Color
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: systemImage)
//                .font(.system(size: 20))
//                .foregroundColor(.white)
//                .padding()
//                .background(color)
//                .clipShape(Circle())
//                .shadow(radius: 5)
//        }
//    }
//}
//
//// Funzioni per i pulsanti
//private func callEmergency() {
//    print("Calling 112...")
////    guard let url = URL(string: "tel://3401915252") else {
////        print("Invalid phone URL")
////        return
////    }
////    if UIApplication.shared.canOpenURL(url) {
////        UIApplication.shared.open(url)
////    } else {
////        print("Cannot make a phone call on this device")
////    }
//// Placeholder per chiamata
//    if let url = URL(string: "tel://\(3401915252)") {
//                    UIApplication.shared.open(url)
//                }
//}
//
//private func startVideoCall() {
//    print("Starting video call...") // Placeholder per videochiamata
//}
//
//private func startChat() {
//    print("Opening chat...") // Placeholder per chat
//}
//
//private func findCity() async -> MKMapItem? {
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = "naples"
//    request.addressFilter = MKAddressFilter(including: .locality)
//    let search = MKLocalSearch(request: request)
//    let response = try? await search.start()
//    return response?.mapItems.first
//}
//
//private func findPoliceStations(in city: MKMapItem) async -> [MKMapItem] {
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = "police"
//    let downtown = MKCoordinateRegion(
//        center: city.placemark.coordinate,
//        span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
//    )
//    request.region = downtown
//    request.regionPriority = .required
//    let search = MKLocalSearch(request: request)
//    let response = try? await search.start()
//    return response?.mapItems ?? []
//}
//struct PoliceStationView_Previews: PreviewProvider {
//    static var previews: some View {
//        PoliceStationView()
//    }
//}
//
//private func callEmergenc() {
//    guard let url = URL(string: "tel://112") else {
//        print("Invalid phone URL")
//        return
//    }
//    if UIApplication.shared.canOpenURL(url) {
//        UIApplication.shared.open(url)
//    } else {
//        print("Cannot make a phone call on this device")
//    }
//}
//import SwiftUI
//import MapKit
//
//struct PoliceStationView: View {
//    @State private var position: MapCameraPosition = .automatic
//    @State private var policestations: [MKMapItem] = []
//    @State private var searchQuery: String = ""
//    @State private var selectedStation: MKMapItem? // Stato per la stazione selezionata
//    @State private var userLocation: CLLocationCoordinate2D? // Posizione dell'utente
//       @State private var route: MKRoute? // Percorso da tracciare
//       @StateObject private var locationManager = LocationManager() // Gestore della posizione
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            // Mappa con selezione
//            Map(position: $position, selection: $selectedStation) {
//                if let userLocation = userLocation {
//                                    Annotation("You", coordinate: userLocation) {
//                                        Image(systemName: "mappin.circle.fill")
//                                            .foregroundColor(.blue)
//                                            .font(.title)
//                                    }
//                                }
//                ForEach(policestations, id: \.self) { police in
//                    Marker(item: police)
//                        .tag(police) // Collega il marker all'elemento
//                }
//                if let route = route {
//                                    MapPolyline(route.polyline)
//                                        .stroke(Color.blue, lineWidth: 5)
//                                }
//            }
//            .task {
//                userLocation = locationManager.currentLocation?.coordinate
//                guard let city = await findCity(named: searchQuery.isEmpty ? "naples" : searchQuery) else { return }
//                
//                   policestations = await findPoliceStations(in: city)
//            }
//            
//            // Modale sempre visibile
//            BottomSheet  {
//                ModalView(
//                    searchQuery: $searchQuery,
//                    selectedStation: selectedStation,
//                    onCall: { callEmergency() },
//                    onVideoCall: { startVideoCall() },
//                    onChat: { startChat() },
//                    onSearch: searchPoliceStations
//                )
//            }
//            .frame(maxHeight: UIScreen.main.bounds.height * 0.4) // Limita l'altezza della modale
//        }
//        .onAppear {
//                   locationManager.requestLocation() // Richiede la posizione
//               }
//        .edgesIgnoringSafeArea(.all) // Per estendere la mappa sotto la modale
//    }
//    private func searchPoliceStations() {
//           Task {
//               guard let city = await findCity(named: searchQuery) else { return }
//               policestations = await findPoliceStations(in: city)
//               position = .region(MKCoordinateRegion(
//                   center: city.placemark.coordinate,
//                   span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
//               ))
//           }
//       }
//}
//private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//    @State var route: MKRoute?
//        let sourcePlacemark = MKPlacemark(coordinate: source)
//        let destinationPlacemark = MKPlacemark(coordinate: destination)
//        
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: sourcePlacemark)
//        request.destination = MKMapItem(placemark: destinationPlacemark)
//        request.transportType = .automobile
//        
//        Task {
//            let directions = MKDirections(request: request)
//            let response = try? await directions.calculate()
//                route = response?.routes.first
//        }
//    }
//// BottomSheet personalizzato con movimento
//struct BottomSheet<Content: View>: View {
//    let content: Content
//    @GestureState private var dragOffset = CGSize.zero
//    @State private var currentOffsetY: CGFloat = UIScreen.main.bounds.height * 0.1 // Centra all'inizio
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Capsule()
//                .fill(Color.gray)
//                .frame(width: 40, height: 6)
//                .padding(.top, 8)
//
//            content
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(radius: 10)
//        }
//        .background(Color.white.opacity(0.8))
//        .offset(y: currentOffsetY + dragOffset.height)
//        .gesture(
//            DragGesture()
//                .updating($dragOffset) { value, state, _ in
//                    state = value.translation
//                }
//                .onEnded { value in
//                    // Adjust the modal position based on the drag
//                    let maxHeight = UIScreen.main.bounds.height * 0.4
//                    let minHeight: CGFloat = 50
//
//                    currentOffsetY = max(minHeight, min(maxHeight, currentOffsetY + value.translation.height))
//                }
//        )
//    }
//}
//
//
//// ModalView con titolo, barra di ricerca, informazioni e pulsanti
//struct ModalView: View {
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
//            HStack {
//                TextField("Enter City Name...", text: $searchQuery)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                Button(action: onSearch) {
//                    Image(systemName: "magnifyingglass")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                }
//            }
//        
//            
//            // Mostra informazioni della stazione selezionata
//            if let station = selectedStation {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Name: \(station.name ?? "N/A")")
//                        .font(.headline)
//                    Text("Address: \(station.placemark.title ?? "N/A")")
//                        .font(.subheadline)
//                   
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
//            Spacer() // Per lasciare spazio sotto
//        }
//        .padding(.top)
//    }
//}
//
//// Pulsante circolare personalizzato
//struct CircularButton: View {
//    let systemImage: String
//    let color: Color
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: systemImage)
//                .font(.system(size: 20))
//                .foregroundColor(.white)
//                .padding()
//                .background(color)
//                .clipShape(Circle())
//                .shadow(radius: 5)
//        }
//    }
//}
//
//// Funzioni per i pulsanti
//private func callEmergency() {
//    print("Calling 112...")
////    guard let url = URL(string: "tel://3401915252") else {
////        print("Invalid phone URL")
////        return
////    }
////    if UIApplication.shared.canOpenURL(url) {
////        UIApplication.shared.open(url)
////    } else {
////        print("Cannot make a phone call on this device")
////    }
//// Placeholder per chiamata
//    if let url = URL(string: "tel://\(3471363018)") {
//                    UIApplication.shared.open(url)
//                }
//}
//
//private func startVideoCall() {
//    print("Starting video call...") // Placeholder per videochiamata
//}
//
//private func startChat() {
//    print("Opening chat...") // Placeholder per chat
//}
//
//private func findCity(named cityName: String) async -> MKMapItem? {
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = cityName
//    request.addressFilter = MKAddressFilter(including: .locality)
//    let search = MKLocalSearch(request: request)
//    let response = try? await search.start()
//    return response?.mapItems.first
//}
//
//private func findPoliceStations(in city: MKMapItem) async -> [MKMapItem] {
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = "police"
//    let region = MKCoordinateRegion(
//        center: city.placemark.coordinate,
//        span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
//    )
//    request.region = region
//    
//    let search = MKLocalSearch(request: request)
//    let response = try? await search.start()
//    return response?.mapItems ?? []
//}
//
//
//
//struct PoliceStationView_Previews: PreviewProvider {
//    static var previews: some View {
//        PoliceStationView()
//    }
//}

import SwiftUI
import MapKit
import Foundation

struct PoliceStationView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var policestations: [MKMapItem] = []
    @State private var searchQuery: String = ""
    @State private var selectedStation: MKMapItem? // Selected station
    @State private var userLocation: CLLocationCoordinate2D? // User location
    @State private var route: MKRoute? // Route to draw
    @State private var distanceToStation: Double? // Distance to the selected station
    @StateObject private var locationManager = LocationManager() // Location manager
    @State private var showmodal: Bool = true
    var body: some View {
        ZStack(alignment: .bottom) {
            // Map with selection
            Map(position: $position, selection: $selectedStation) {
                if let userLocation = userLocation {
                    Annotation("You", coordinate: userLocation) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
                ForEach(policestations, id: \.self) { police in
                    Marker(item: police)
                        .tag(police) // Link marker to item
                }
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(Color.blue, lineWidth: 5)
                }
            }
            .task {
                userLocation = locationManager.currentLocation?.coordinate
                guard let city = await findCity(named: searchQuery.isEmpty ? "naples" : searchQuery) else { return }
                policestations = await findPoliceStations(in: city)
            }
            
            // Always visible Modal
            BottomSheet (showModal: $showmodal){
                ModalView(
                    searchQuery: $searchQuery,
                    selectedStation: selectedStation,
                    distanceToStation: distanceToStation, // Pass distance here
                    route: route, // Pass route here
                    onCall: { callEmergency() },
                    onVideoCall: { VideoCall() },
                    onChat: { startChat() },
                    onSearch: searchPoliceStations
                )
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.4) // Limit modal height
        }
        .onAppear {
            locationManager.requestLocation() // Request location
        }
        .edgesIgnoringSafeArea(.all) // Extend map below modal
        .onChange(of: selectedStation) { newStation in
            if let newStation = newStation, let userLocation = userLocation {
                // Calculate distance and route when a new station is selected
                calculateRoute(from: userLocation, to: newStation.placemark.coordinate)
                calculateDistance(from: userLocation, to: newStation.placemark.coordinate)
            }
        }
    }
    
    private func searchPoliceStations() {
        Task {
            guard let city = await findCity(named: searchQuery) else { return }
            policestations = await findPoliceStations(in: city)
            position = .region(MKCoordinateRegion(
                center: city.placemark.coordinate,
                span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
            ))
        }
    }
    
    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
    private func calculateDistance(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        let distanceInMeters = sourceLocation.distance(from: destinationLocation)
        distanceToStation = distanceInMeters / 1000 // Convert to kilometers
    }
}

struct PoliceStationView_Previews: PreviewProvider {
    static var previews: some View {
        PoliceStationView()
    }
}
