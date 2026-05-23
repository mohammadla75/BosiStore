//
//  AddressView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI
import CoreLocation

struct AddressListView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    @State private var showAddForm = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 16) {
                header
                
                if let addresses = authManager.currentUser?.addresses, !addresses.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(Array(addresses.enumerated()), id: \.element.id) { index, address in
                                addressRow(address: address, index: index)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                } else {
                    Spacer()
                    Text("No addresses yet")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showAddForm) { AddAddressView() }
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
            
            Text(localization.str("addresses"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button { showAddForm = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private func addressRow(address: UserAddress, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(address.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                if address.isDefault {
                    Text("Default")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.green.opacity(0.2)))
                }
                
                Spacer()
                
                Button {
                    authManager.removeAddress(at: index)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }
            
            Text("\(address.street), \(address.city)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Text("\(address.state), \(address.country) \(address.zipCode)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            if address.latitude != 0 || address.longitude != 0 {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.cyan)
                    Text("\(address.latitude ?? 0, specifier: "%.4f"), \(address.longitude ?? 0, specifier: "%.4f")")
                        .font(.system(size: 10))
                        .foregroundColor(.cyan)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(radius: 14)
    }
}
