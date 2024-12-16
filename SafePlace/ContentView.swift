//
//  ContentView.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 16/12/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showModal = false
    

    var body: some View {
        ZStack {
            // PoliceStationView come sfondo
            PoliceStationView()
                .edgesIgnoringSafeArea(.all)

            // Modale in primo piano
           
        }
       
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
