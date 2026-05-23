//
//  CartItem.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    var id: String
    var product: Product
    var quantity: Int
    
    init(id: String = UUID().uuidString, product: Product, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.id == rhs.id && lhs.quantity == rhs.quantity
    }
}
