# SafePlace App

SafePlace is an application designed to help users quickly locate nearby police stations and contact emergency numbers.

## Key Features

1. **Interactive Map**:
   - Displays the user's current location and nearby police stations.
   - Provides a route to a selected police station.

2. **Search Bar**:
   - Allows users to search for police stations in a specific city.

3. **Emergency Contacts**:
   - Enables calls and video calls using the emergency contacts saved on the device.

4. **Emergency Chat**:
   - A placeholder for future emergency chat functionality.

## Requirements

- iOS 14.0 or higher
- Access to location services and contacts
- A FaceTime-compatible device for video calls

## Project Architecture

The project is divided into multiple Swift files for modularity:

1. **PoliceStationView.swift**:
   - Manages the map, search bar, and displays police station details.

2. **BottomSheet.swift**:
   - Implements the design for the bottom modal view.

3. **ModalView.swift**:
   - Displays police station details and buttons for emergency actions.

4. **EmergencyCall.swift**:
   - Contains functions for calling and video calling emergency contacts.

5. **LocationManager.swift**:
   - Handles retrieving the user's location.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/username/safeplace.git

