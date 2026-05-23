//
//  CartView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var localization: LocalizationManager
    @State private var showCheckout = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if cartManager.items.isEmpty {
                emptyState
            } else {
                VStack(spacing: 0) {
                    cartHeader
                    cartList
                    Spacer()
                    checkoutBar
                }
            }
        }
        .alert(localization.str("complete_buy"), isPresented: $showCheckout) {
            Button(localization.str("confirm"), role: .destructive) {
                cartManager.clearCart()
            }
            Button(localization.str("cancel"), role: .cancel) {}
        } message: {
            Text("\(localization.str("confirm_buy")) $\(cartManager.totalPrice, specifier: "%.0f")?")
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundStyle(LinearGradient(colors: [.purple.opacity(0.5), .cyan.opacity(0.5)], startPoint: .top, endPoint: .bottom))
            Text(localization.str("empty_cart"))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(localization.str("empty_cart_sub"))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    private var cartHeader: some View {
        HStack {
            Text(localization.str("cart"))
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text("\(cartManager.itemCount) \(localization.str("items"))")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3)) {
                    cartManager.clearCart()
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                    Text(localization.str("clear_cart"))
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.red.opacity(0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .glassBackground(radius: 10)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 70)
        .padding(.bottom, 10)
    }
    
    private var cartList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(cartManager.items) { item in
                    CartItemRow(item: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    
    private var checkoutBar: some View {
        VStack(spacing: 14) {
            VStack(spacing: 8) {
                HStack {
                    Text(localization.str("subtotal"))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("$\(cartManager.totalOriginalPrice, specifier: "%.0f")")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .strikethrough()
                }
                HStack {
                    Text(localization.str("savings"))
                        .font(.system(size: 13))
                        .foregroundColor(.green)
                    Spacer()
                    Text("-$\(cartManager.totalSavings, specifier: "%.0f")")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.green)
                }
                Divider().background(Color.white.opacity(0.2))
                HStack {
                    Text(localization.str("payable"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(cartManager.totalPrice, specifier: "%.0f")")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing))
                }
            }
            
            Button {
                showCheckout = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                    Text(localization.str("checkout"))
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [.purple, .blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .purple.opacity(0.4), radius: 15, x: 0, y: 8)
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.2), lineWidth: 1))
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -10)
        )
        .padding(.bottom, 80)
        .padding(.horizontal)

    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [.white.opacity(0.08), .white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: item.product.imageName)
                        .font(.system(size: 26))
                        .foregroundStyle(LinearGradient(colors: [.purple, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("$\(item.product.discountedPrice, specifier: "%.0f")")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing))
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        cartManager.removeOne(product: item.product)
                    }
                } label: {
                    Image(systemName: item.quantity == 1 ? "trash" : "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(item.quantity == 1 ? .red : .white)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(.ultraThinMaterial))
                        .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                }
                
                Text("\(item.quantity)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 20)
                
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        cartManager.addToCart(product: item.product)
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)))
                }
            }
        }
        .padding(12)
        .glassCard(radius: 16)
    }
}
