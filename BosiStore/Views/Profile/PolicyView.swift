//
//  PolicyView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct PolicyView: View {
    let titleKey: String
    let contentKey: String
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                    
                    Spacer()
                    
                    Text(localization.str(titleKey))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Icon Shield for Privacy/Terms
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(RadialGradient(colors: [.teal.opacity(0.3), .clear], center: .center, startRadius: 0, endRadius: 50))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: titleKey == "privacy" ? "lock.shield.fill" : "doc.text.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(LinearGradient(colors: [.teal, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                            }
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        
                        Text(localization.str(contentKey))
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(8)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassCard(radius: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
