import Foundation
import SwiftUI
internal import Combine


final class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    
    init() {
        loadCart()
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.discountedPrice * Double($1.quantity)) }
    }
    
    var totalOriginalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var totalSavings: Double {
        totalOriginalPrice - totalPrice
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    func addToCart(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
        saveCart()
        haptic(.medium)
    }
    
    func removeOne(product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
        saveCart()
        haptic(.light)
    }
    
    func deleteItem(product: Product) {
        items.removeAll { $0.product.id == product.id }
        saveCart()
        haptic(.medium)
    }
    
    func clearCart() {
        items.removeAll()
        saveCart()
        haptic(.heavy)
    }
    
    func isInCart(product: Product) -> Bool {
        items.contains { $0.product.id == product.id }
    }
    
    func quantity(for product: Product) -> Int {
        items.first { $0.product.id == product.id }?.quantity ?? 0
    }
    
    private func saveCart() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "bosi_cart")
        }
    }
    
    private func loadCart() {
        guard let data = UserDefaults.standard.data(forKey: "bosi_cart"),
              let decoded = try? JSONDecoder().decode([CartItem].self, from: data) else { return }
        items = decoded
    }
    
    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
