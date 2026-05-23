import SwiftUI

// MARK: - Glass Background Modifier
struct GlassBackgroundModifier: ViewModifier {
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
            )
    }
}

// MARK: - Glass Card Modifier
struct GlassCardModifier: ViewModifier {
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: radius)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
            )
    }
}

extension View {
    func glassBackground(radius: CGFloat = 20) -> some View {
        modifier(GlassBackgroundModifier(radius: radius))
    }
    
    func glassCard(radius: CGFloat = 24) -> some View {
        modifier(GlassCardModifier(radius: radius))
    }
}

// MARK: - Animated Background
struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.03, blue: 0.12),
                    Color(red: 0.08, green: 0.04, blue: 0.18),
                    Color(red: 0.03, green: 0.08, blue: 0.2)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            
            Circle()
                .fill(RadialGradient(colors: [Color.purple.opacity(0.3), .clear], center: .center, startRadius: 0, endRadius: 150))
                .frame(width: 300, height: 300)
                .offset(x: animate ? 100 : -100, y: animate ? -150 : 150)
                .blur(radius: 30)
            
            Circle()
                .fill(RadialGradient(colors: [Color.blue.opacity(0.25), .clear], center: .center, startRadius: 0, endRadius: 120))
                .frame(width: 250, height: 250)
                .offset(x: animate ? -80 : 80, y: animate ? 100 : -100)
                .blur(radius: 25)
            
            Circle()
                .fill(RadialGradient(colors: [Color.cyan.opacity(0.2), .clear], center: .center, startRadius: 0, endRadius: 100))
                .frame(width: 200, height: 200)
                .offset(x: animate ? 60 : -60, y: animate ? 180 : -50)
                .blur(radius: 20)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

// MARK: - Glass TextField
struct GlassTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .tint(.purple)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .tint(.purple)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .glassBackground(radius: 14)
    }
}
