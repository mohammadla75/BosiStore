//
//  SettingsView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager // Added AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var showDeleteAlert = false // For confirmation dialog
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    languageSection
                    policiesSection
                    
                    if authManager.isAuthenticated {
                        dangerZoneSection // Show only if user is logged in
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .sheet(isPresented: $showTerms) { PolicyView(titleKey: "terms", contentKey: "terms_content") }
        .sheet(isPresented: $showPrivacy) { PolicyView(titleKey: "privacy", contentKey: "privacy_content") }
        // Delete Account Confirmation Alert
        .alert(localization.str("delete_confirm_title"), isPresented: $showDeleteAlert) {
            Button(localization.str("cancel"), role: .cancel) { }
            Button(localization.str("delete"), role: .destructive) {
                authManager.deleteAccount()
                dismiss() // Close settings page after deletion
            }
        } message: {
            Text(localization.str("delete_confirm_msg"))
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
            Text(localization.str("settings"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 32, height: 32)
        }
    }
    
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.teal)
                Text(localization.str("language"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                ForEach(AppLanguage.allCases, id: \.rawValue) { language in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            localization.setLanguage(language)
                        }
                    } label: {
                        HStack {
                            Text(language.displayName)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if localization.currentLanguage == language {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(localization.currentLanguage == language ? Color.teal.opacity(0.2) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(localization.currentLanguage == language ? Color.teal.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(18)
        .glassCard(radius: 18)
    }
    
    private var policiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "shield.fill")
                    .foregroundColor(.cyan)
                Text("Legal & Security") // Hardcoded english or localization
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
    
    // MARK: - Danger Zone Section
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(localization.str("danger_zone"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            Button {
                showDeleteAlert = true
            } label: {
                HStack {
                    Text(localization.str("delete_account"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.red)
                    Spacer()
                    Image(systemName: "trash.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(18)
        .glassCard(radius: 18)
    }
}
