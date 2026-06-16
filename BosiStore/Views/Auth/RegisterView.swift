import Foundation
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptedTerms = false
    
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var animateIn = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer(minLength: 60)
                    
                    header
                    form
                    termsCheckbox
                    registerButton
                    loginLink
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .alert(localization.str(authManager.alertMessage), isPresented: $authManager.showAlert) {
            Button("OK", role: .cancel) {
                if authManager.alertMessage == "reg_success" {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showTerms) { PolicyView(titleKey: "terms", contentKey: "terms_content") }
        .sheet(isPresented: $showPrivacy) { PolicyView(titleKey: "privacy", contentKey: "privacy_content") }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { animateIn = true }
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 44))
                .foregroundStyle(LinearGradient(colors: [.teal, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text(localization.str("register"))
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text(localization.str("register_sub"))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .opacity(animateIn ? 1 : 0)
    }
    
    private var form: some View {
        VStack(spacing: 12) {
            GlassTextField(placeholder: localization.str("full_name"), text: $fullName, icon: "person.fill")
            GlassTextField(placeholder: localization.str("email"), text: $email, icon: "envelope.fill")
            GlassTextField(placeholder: localization.str("phone"), text: $phone, icon: "phone.fill")
            GlassTextField(placeholder: localization.str("password"), text: $password, icon: "lock.fill", isSecure: true)
            GlassTextField(placeholder: localization.str("confirm_pass"), text: $confirmPassword, icon: "lock.rotation", isSecure: true)
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
    }
    
    private var termsCheckbox: some View {
        HStack(alignment: .center, spacing: 10) {
            Button {
                withAnimation { acceptedTerms.toggle() }
            } label: {
                Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundStyle(acceptedTerms ? LinearGradient(colors: [.teal, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.gray, .gray], startPoint: .top, endPoint: .bottom))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(localization.str("accept_terms"))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Button { showTerms = true } label: {
                        Text(localization.str("terms"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.teal)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(localization.str("and"))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Button { showPrivacy = true } label: {
                        Text(localization.str("privacy"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.cyan)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 4)
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
    }
    
    private var registerButton: some View {
        Button {
            guard acceptedTerms else {
                authManager.alertMessage = "terms_error"
                authManager.showAlert = true
                return
            }
            
            let success = authManager.register(
                fullName: fullName,
                email: email,
                phone: phone,
                password: password,
                confirmPassword: confirmPassword
            )
            if success {
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 18))
                Text(localization.str("register"))
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: acceptedTerms ? [.teal, .cyan] : [.gray.opacity(0.5), .gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: acceptedTerms ? .teal.opacity(0.4) : .clear, radius: 15, x: 0, y: 8)
            )
        }
        .disabled(!acceptedTerms)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var loginLink: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Text(localization.str("has_account"))
                    .foregroundColor(.gray)
                Text(localization.str("login"))
                    .foregroundColor(.teal)
                    .fontWeight(.semibold)
            }
            .font(.system(size: 14))
        }
    }
}
