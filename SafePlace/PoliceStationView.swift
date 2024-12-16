//
//  PoliceStationView.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 16/12/24.
//
import SwiftUI
import MapKit

struct PoliceStationView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var policestations: [MKMapItem] = []
    @State private var searchQuery: String = ""
    @State private var selectedStation: MKMapItem? // Stato per la stazione selezionata

    // Stati per gli alert
    @State private var showAlert: Bool = false
    @State private var currentAction: (() -> Void)? // Azione da eseguire dopo la conferma

    var body: some View {
        ZStack(alignment: .bottom) {
            // Mappa con selezione
            Map(position: $position, selection: $selectedStation) {
                ForEach(policestations, id: \.self) { police in
                    Marker(item: police)
                        .tag(police) // Collega il marker all'elemento
                }
            }
            .task {
                guard let naples = await findCity() else { return }
                policestations = await findPoliceStations(in: naples)
            }
            
            // Modale sempre visibile
            BottomSheet {
                ModalView(
                    searchQuery: $searchQuery,
                    selectedStation: selectedStation,
                    onCall: { confirmAction(callEmergency) },
                    onVideoCall: { confirmAction(startVideoCall) },
                    onChat: { confirmAction(startChat) }
                )
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.4) // Limita l'altezza della modale
        }
        .edgesIgnoringSafeArea(.all) // Per estendere la mappa sotto la modale
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This action cannot be undone."),
                primaryButton: .default(Text("Yes"), action: {
                    currentAction?()
                }),
                secondaryButton: .cancel()
            )
        }
    }

    // Conferma azione con alert
    private func confirmAction(_ action: @escaping () -> Void) {
        currentAction = action
        showAlert = true
    }
}

// BottomSheet personalizzato
struct BottomSheet<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)
            
            content
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
        }
        .background(Color.white.opacity(0.8))
    }
}

// ModalView con titolo, barra di ricerca, informazioni e pulsanti
struct ModalView: View {
    @Binding var searchQuery: String
    var selectedStation: MKMapItem?
    var onCall: () -> Void
    var onVideoCall: () -> Void
    var onChat: () -> Void

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
            
            TextField("Search..", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Mostra informazioni della stazione selezionata
            if let station = selectedStation {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(station.name ?? "N/A")")
                        .font(.headline)
                    Text("Address: \(station.placemark.title ?? "N/A")")
                        .font(.subheadline)
                    Text("Coordinates: \(station.placemark.coordinate.latitude), \(station.placemark.coordinate.longitude)")
                        .font(.subheadline)
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
            
            Spacer() // Per lasciare spazio sotto
        }
        .padding(.top)
    }
}

// Pulsante circolare personalizzato
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

// Funzioni per i pulsanti
private func callEmergency() {
    print("Calling 112...") // Placeholder per chiamata
}

private func startVideoCall() {
    print("Starting video call...") // Placeholder per videochiamata
}

private func startChat() {
    print("Opening chat...") // Placeholder per chat
}

private func findCity() async -> MKMapItem? {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = "naples"
    request.addressFilter = MKAddressFilter(including: .locality)
    let search = MKLocalSearch(request: request)
    let response = try? await search.start()
    return response?.mapItems.first
}

private func findPoliceStations(in city: MKMapItem) async -> [MKMapItem] {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = "police"
    let downtown = MKCoordinateRegion(
        center: city.placemark.coordinate,
        span: .init(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )
    request.region = downtown
    request.regionPriority = .required
    let search = MKLocalSearch(request: request)
    let response = try? await search.start()
    return response?.mapItems ?? []
}

struct PoliceStationView_Previews: PreviewProvider {
    static var previews: some View {
        PoliceStationView()
    }
}
