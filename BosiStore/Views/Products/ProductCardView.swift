import SwiftUI

struct ProductCardView: View {
    let product: Product
    var namespace: Namespace.ID
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [.white.opacity(0.08), .white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 110)
                    .overlay(
                        Image(systemName: product.imageName)
                            .font(.system(size: 40))
                            .foregroundStyle(LinearGradient(colors: [.purple, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .matchedGeometryEffect(id: "img_\(product.id)", in: namespace)
                    )
                
                if product.discountPercentage > 0 {
                    Text("\(product.discountPercentage)%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)))
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "name_\(product.id)", in: namespace)
                
                Text(product.shortDescription)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(product.discountedPrice, specifier: "%.0f")")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing))
                    
                    Spacer()
                    
                    Button {
                        cartManager.addToCart(product: product)
                    } label: {
                        Image(systemName: cartManager.isInCart(product: product) ? "checkmark" : "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(
                                Circle().fill(
                                    LinearGradient(colors: cartManager.isInCart(product: product) ? [.green, .cyan] : [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            )
                    }
                }
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(product.rating) ? "star.fill" : "star")
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .padding(8)
        .glassCard(radius: 20)
    }
}
