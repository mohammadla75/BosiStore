//
//  ProfileView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var showAddresses = false
    @State private var showSettings = false
    @State private var showTerms = false
    @State private var showPrivacy = false

    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if authManager.isAuthenticated {
                authenticatedView
            } else {
                LoginView()
            }
        }
        .sheet(isPresented: $showAddresses) { AddressListView() }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .sheet(isPresented: $showTerms) { PolicyView(titleKey: "terms", contentKey: "terms_content") }
        .sheet(isPresented: $showPrivacy) { PolicyView(titleKey: "privacy", contentKey: "privacy_content") }

    }
    
    private var authenticatedView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Spacer(minLength: 60)
                
                profileHeader
                menuItems
                policiesSection

                logoutButton
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [.purple.opacity(0.6), .blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(authManager.currentUser?.fullName.prefix(1) ?? "U"))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                )
                .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 2))
            
            Text(authManager.currentUser?.fullName ?? "")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(authManager.currentUser?.email ?? "")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Text(authManager.currentUser?.phone ?? "")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 20)
    }
    
    private var menuItems: some View {
        VStack(spacing: 10) {
            menuRow(icon: "mappin.circle.fill", title: localization.str("addresses"), color: .blue) {
                showAddresses = true
            }
            menuRow(icon: "gearshape.fill", title: localization.str("settings"), color: .gray) {
                showSettings = true
            }
            menuRow(icon: "bag.fill", title: localization.str("app_name"), color: .purple) {}
        }
    }
    
    private func menuRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(14)
            .glassCard(radius: 14)
        }
    }
    
    private var logoutButton: some View {
        Button {
            authManager.logout()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16))
                Text(localization.str("logout"))
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.red.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.red.opacity(0.3), lineWidth: 1))
            )
        }
        .padding(.top, 20)
    }
    
    private var policiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(.cyan)
                Text("Legal & Security")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 0) {
                Button { showTerms = true } label: {
                    HStack {
                        Text(localization.str("terms"))
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 14)
                }
                
                Divider().background(Color.white.opacity(0.2))
                
                Button { showPrivacy = true } label: {
                    HStack {
                        Text(localization.str("privacy"))
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 14)
                }
            }
        }
        .padding(18)
        .glassCard(radius: 18)
    }
}
