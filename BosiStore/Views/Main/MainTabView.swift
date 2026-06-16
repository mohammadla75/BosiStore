import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    ProductListView()
                case 1:
                    CartView()
                case 2:
                    ProfileView()
                default:
                    ProductListView()
                }
            }
            
            tabBar
        }
        .environment(\.layoutDirection, localization.layoutDirection)
    }
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(icon: "square.grid.2x2.fill", title: localization.str("products"), tag: 0)
            tabButton(icon: "cart.fill", title: localization.str("cart"), tag: 1, badge: cartManager.itemCount)
            tabButton(icon: "person.fill", title: localization.str("profile"), tag: 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(colors: [.white.opacity(0.4), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                )
                .shadow(color: .teal.opacity(0.3), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 30)
        .padding(.bottom, 10)
    }
    
    private func tabButton(icon: String, title: String, tag: Int, badge: Int = 0) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(selectedTab == tag ? .teal : .gray)
                        .scaleEffect(selectedTab == tag ? 1.15 : 1.0)
                    
                    if badge > 0 {
                        Text("\(badge)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .background(Circle().fill(Color.red))
                            .offset(x: 8, y: -6)
                    }
                }
                Text(title)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(selectedTab == tag ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
