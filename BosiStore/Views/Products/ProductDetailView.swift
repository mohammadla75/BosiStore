import SwiftUI

struct ProductDetailView: View {
    let product: Product
    var namespace: Namespace.ID
    @Binding var isPresented: Bool
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedColor = 0
    @State private var showToast = false
    @State private var animateIn = false
    @State private var showReviews = false
    @State private var showAddReview = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    topBar
                    productImage
                    info
                    colorsSection
                    descriptionCard
                    features
                    reviewButton
                    priceSection
                    addToCartButton
                    Spacer(minLength: 100)
                }
                .padding(.top, 50)
            }
            
            if showToast {
                VStack {
                    toastView
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(5)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) { animateIn = true }
        }
        .sheet(isPresented: $showReviews) { ReviewListView(product: product) }
        .sheet(isPresented: $showAddReview) { AddReviewView(product: product) }
    }
    
    private var topBar: some View {
        HStack {
            Button { close() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(.ultraThinMaterial))
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
            }
            Spacer()
            Text(product.category)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .glassBackground(radius: 10)
            Spacer()
            Button {} label: {
                Image(systemName: "heart")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(.ultraThinMaterial))
                    .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var productImage: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [.purple.opacity(0.3), .clear], center: .center, startRadius: 0, endRadius: 120))
                .frame(width: 240, height: 240)
                .blur(radius: 25)
            
            Image(systemName: product.imageName)
                .font(.system(size: 80))
                .foregroundStyle(LinearGradient(colors: [.purple, .cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .matchedGeometryEffect(id: "img_\(product.id)", in: namespace)
                .shadow(color: .purple.opacity(0.5), radius: 30)
        }
        .frame(height: 200)
    }
    
    private var info: some View {
        VStack(spacing: 8) {
            Text(product.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .matchedGeometryEffect(id: "name_\(product.id)", in: namespace)
            
            Text(product.shortDescription)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            HStack(spacing: 4) {
                ForEach(0..<5) { i in
                    Image(systemName: i < Int(product.rating) ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                }
                Text("\(product.rating, specifier: "%.1f")")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                Text("(\(product.reviewCount))")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 20)
    }
    
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(localization.str("colors"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(product.colors.enumerated()), id: \.offset) { index, color in
                        Text(color)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedColor == index ? .white : .gray)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(
                                    selectedColor == index ?
                                    AnyShapeStyle(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)) :
                                    AnyShapeStyle(Color.white.opacity(0.08))
                                )
                            )
                            .overlay(Capsule().stroke(Color.white.opacity(selectedColor == index ? 0 : 0.15), lineWidth: 1))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) { selectedColor = index }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.str("about"))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(product.fullDescription)
                .font(.system(size: 13))
                .foregroundColor(.gray.opacity(0.9))
                .lineSpacing(5)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(radius: 18)
        .padding(.horizontal, 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var features: some View {
        HStack(spacing: 0) {
            featureItem(icon: "shippingbox.fill", text: localization.str("free_ship"))
            featureItem(icon: "arrow.counterclockwise", text: localization.str("return_policy"))
            featureItem(icon: "checkmark.seal.fill", text: localization.str("authentic"))
        }
        .padding(14)
        .glassCard(radius: 16)
        .padding(.horizontal, 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    private func featureItem(icon: String, text: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(LinearGradient(colors: [.purple, .cyan], startPoint: .top, endPoint: .bottom))
            Text(text)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var reviewButton: some View {
        HStack {
            Button { showReviews = true } label: {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.purple)
                    Text(localization.str("reviews"))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(14)
                .glassCard(radius: 14)
            }
            
            Button { showAddReview = true } label: {
                Image(systemName: "plus.message.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
            }
        }
        .padding(.horizontal, 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var priceSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("$\(product.price, specifier: "%.0f")")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .strikethrough(color: .red)
                    Text("\(product.discountPercentage)% \(localization.str("discount"))")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)))
                }
                Text("$\(product.discountedPrice, specifier: "%.0f")")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(localization.str("savings"))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Text("$\(product.price - product.discountedPrice, specifier: "%.0f")")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
            }
        }
        .padding(18)
        .glassCard(radius: 16)
        .padding(.horizontal, 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var addToCartButton: some View {
        Button { addToCart() } label: {
            HStack(spacing: 10) {
                Image(systemName: cartManager.isInCart(product: product) ? "checkmark.circle.fill" : "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                Text(cartManager.isInCart(product: product) ? localization.str("added_to_cart") : localization.str("add_to_cart"))
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(
                        colors: cartManager.isInCart(product: product) ? [.green, .cyan] : [.purple, .blue],
                        startPoint: .leading, endPoint: .trailing
                    ))
                    .shadow(color: .purple.opacity(0.4), radius: 15, x: 0, y: 8)
            )
        }
        .padding(.horizontal, 16)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var toastView: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(localization.str("added_to_cart"))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .glassCard(radius: 25)
        .padding(.top, 60)
    }
    
    private func close() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            animateIn = false
            isPresented = false
        }
    }
    
    private func addToCart() {
        cartManager.addToCart(product: product)
        withAnimation(.spring(response: 0.4)) { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showToast = false }
        }
    }
}
