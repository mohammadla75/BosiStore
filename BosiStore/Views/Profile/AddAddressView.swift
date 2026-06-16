//
//  AddAddressView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI
import CoreLocation
internal import Combine

class LocationFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var fetched: Bool = false
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
            fetched = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

struct AddAddressView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationFetcher = LocationFetcher()
    
    @State private var addressTitle = "Home"
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    @State private var isDefault = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    header
                    form
                    locationSection
                    saveButton
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            Spacer()
            Text(localization.str("add_address"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 32, height: 32)
        }
    }
    
    private var form: some View {
        VStack(spacing: 12) {
            GlassTextField(placeholder: localization.str("address_title"), text: $addressTitle, icon: "tag.fill")
            GlassTextField(placeholder: localization.str("street"), text: $street, icon: "house.fill")
            GlassTextField(placeholder: localization.str("city"), text: $city, icon: "building.2.fill")
            GlassTextField(placeholder: localization.str("state"), text: $state, icon: "map.fill")
            GlassTextField(placeholder: localization.str("zip"), text: $zipCode, icon: "number")
            GlassTextField(placeholder: localization.str("country"), text: $country, icon: "globe")
            
            Toggle(isOn: $isDefault) {
                Text("Default Address")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .tint(.teal)
            .padding(.horizontal, 4)
        }
    }
    
    private var locationSection: some View {
        VStack(spacing: 12) {
            Button {
                locationFetcher.requestLocation()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 18))
                    Text(localization.str("use_location"))
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .glassBackground(radius: 14)
            }
            
            if locationFetcher.fetched {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(localization.str("lat")): \(locationFetcher.latitude, specifier: "%.6f")")
                            .font(.system(size: 12))
                            .foregroundColor(.cyan)
                        Text("\(localization.str("lng")): \(locationFetcher.longitude, specifier: "%.6f")")
                            .font(.system(size: 12))
                            .foregroundColor(.cyan)
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .padding(12)
                .glassBackground(radius: 12)
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            let address = UserAddress(
                title: addressTitle,
                street: street,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country,
                latitude: locationFetcher.latitude,
                longitude: locationFetcher.longitude,
                isDefault: isDefault
            )
            authManager.addAddress(address)
            dismiss()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                Text(localization.str("save_address"))
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(
                        colors: [.green, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .shadow(color: .green.opacity(0.3), radius: 15, x: 0, y: 8)
            )
        }
        .padding(.top, 10)
    }
}
