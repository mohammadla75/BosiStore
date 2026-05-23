//
//  LoginView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var animateIn = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Spacer(minLength: 80)
                    
                    logo
                    loginForm
                    loginButton
                    registerLink
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .alert(localization.str(authManager.alertMessage), isPresented: $authManager.showAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { animateIn = true }
        }
    }
    
    private var logo: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [.purple.opacity(0.3), .clear], center: .center, startRadius: 0, endRadius: 60))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "bag.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(LinearGradient(colors: [.purple, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            
            Text(localization.str("app_name"))
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(localization.str("login_sub"))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : -20)
    }
    
    private var loginForm: some View {
        VStack(spacing: 14) {
            GlassTextField(placeholder: localization.str("email"), text: $email, icon: "envelope.fill")
            GlassTextField(placeholder: localization.str("password"), text: $password, icon: "lock.fill", isSecure: true)
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
    }
    
    private var loginButton: some View {
        Button {
            let success = authManager.login(email: email, password: password)
            if success {
                email = ""
                password = ""
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 18))
                Text(localization.str("login"))
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: .purple.opacity(0.4), radius: 15, x: 0, y: 8)
            )
        }
        .opacity(animateIn ? 1 : 0)
    }
    
    private var registerLink: some View {
        Button {
            showRegister = true
        } label: {
            HStack(spacing: 4) {
                Text(localization.str("no_account"))
                    .foregroundColor(.gray)
                Text(localization.str("register"))
                    .foregroundColor(.purple)
                    .fontWeight(.semibold)
            }
            .font(.system(size: 14))
        }
    }
}
