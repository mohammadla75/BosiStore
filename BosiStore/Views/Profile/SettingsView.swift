//
//  SettingsView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 20) {
                header
                languageSection
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
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
                    .foregroundColor(.purple)
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
                                .fill(localization.currentLanguage == language ? Color.purple.opacity(0.2) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(localization.currentLanguage == language ? Color.purple.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(18)
        .glassCard(radius: 18)
    }
}
