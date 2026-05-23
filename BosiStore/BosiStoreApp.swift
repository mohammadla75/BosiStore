//
//  BosiStoreApp.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import SwiftUI

@main
struct BosiStoreApp: App {
    @StateObject private var cartManager = CartManager()
    @StateObject private var authManager = AuthManager()
    @StateObject private var reviewManager = ReviewManager()
    @StateObject private var localization = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(cartManager)
                .environmentObject(authManager)
                .environmentObject(reviewManager)
                .environmentObject(localization)
                .preferredColorScheme(.dark)
        }
    }
}
