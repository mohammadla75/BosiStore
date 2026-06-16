import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedProduct: Product? = nil
    @State private var showDetail = false
    @State private var searchText = ""
    @Namespace private var animation
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var filtered: [Product] {
        if searchText.isEmpty { return Product.sampleProducts }
        return Product.sampleProducts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    searchBar
                    categories
                    grid
                    Spacer(minLength: 100)
                }
            }
            
            if showDetail, let product = selectedProduct {
                ProductDetailView(product: product, namespace: animation, isPresented: $showDetail)
                    .transition(.opacity.combined(with: .scale(scale: 0.93)))
                    .zIndex(10)
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(localization.str("app_name"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text(localization.str("special"))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(localization.str("search"), text: $searchText)
                .foregroundColor(.white)
                .tint(.teal)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassBackground(radius: 16)
        .padding(.horizontal, 16)
    }
    
    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(["All", "Loose Stones", "Rings", "Necklaces", "Bracelets", "Accessories", "Collectibles"], id: \.self) { cat in
                    let isActive = (cat == "All" && searchText.isEmpty) || searchText == cat
                    Text(cat)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isActive ? .white : .gray)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(isActive ? AnyShapeStyle(LinearGradient(colors: [.teal, .cyan], startPoint: .leading, endPoint: .trailing)) : AnyShapeStyle(Color.white.opacity(0.08)))
                        )
                        .overlay(Capsule().stroke(Color.white.opacity(isActive ? 0 : 0.15), lineWidth: 1))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                searchText = cat == "All" ? "" : cat
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(filtered) { product in
                ProductCardView(product: product, namespace: animation)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            selectedProduct = product
                            showDetail = true
                        }
                    }
            }
        }
        .padding(.horizontal, 16)
    }
}
