//
//  Product.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var name: String
    var shortDescription: String
    var fullDescription: String
    var price: Double
    var discountedPrice: Double
    var imageName: String
    var category: String
    var rating: Double
    var reviewCount: Int
    var colors: [String]
    
    var discountPercentage: Int {
        Int(((price - discountedPrice) / price) * 100)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let sampleProducts: [Product] = [
        Product(
            id: "1",
            name: "Ajami San Turquoise",
            shortDescription: "Highest purity fleshy core turquoise stone",
            fullDescription: "The absolute pinnacle of luxury. This Ajami San turquoise stone features a completely smooth, matrix-free surface with the deepest Persian blue color. Highly sought after by collectors and royalty in the Persian Gulf region. Its impressive size and flawless cut make it the perfect centerpiece for a mastercrafted ring.",
            price: 8500.0,
            discountedPrice: 7765.0,
            imageName: "product_ajami",
            category: "Loose Stones",
            rating: 5.0,
            reviewCount: 124,
            colors: ["Azure Blue", "Deep Royal Blue"]
        ),
        Product(
            id: "2",
            name: "Shajari Matrix Ring",
            shortDescription: "Handcrafted silver ring with spiderweb turquoise",
            fullDescription: "A masterpiece of traditional jewelry making. This ring features a stunning Shajari (spiderweb) turquoise stone with beautiful dark matrix patterns naturally formed over thousands of years. Set in heavy, hand-engraved 925 sterling silver.",
            price: 2400.0,
            discountedPrice: 2100.0,
            imageName: "product_shajari_ring",
            category: "Rings",
            rating: 4.8,
            reviewCount: 342,
            colors: ["Silver", "Platinum"]
        ),
        Product(
            id: "3",
            name: "Royal Blue Pendant",
            shortDescription: "18K Gold necklace with pure turquoise drop",
            fullDescription: "Elegance defined. A tear-drop shaped pure Neyshabur turquoise stone elegantly mounted on an 18K solid gold chain. The contrast between the bright Persian blue and the warm gold creates a striking and luxurious appearance suitable for the most exclusive events.",
            price: 4200.0,
            discountedPrice: 3850.0,
            imageName: "product_pendant",
            category: "Necklaces",
            rating: 4.9,
            reviewCount: 89,
            colors: ["Gold", "Rose Gold"]
        ),
        Product(
            id: "4",
            name: "Imperial Cufflinks",
            shortDescription: "Platinum cufflinks with vintage turquoise",
            fullDescription: "The ultimate statement of executive style. These bespoke platinum cufflinks feature twin perfectly matched, vintage turquoise stones. A subtle yet powerful accessory that demonstrates impeccable taste and appreciation for rare gemstones.",
            price: 1800.0,
            discountedPrice: 1550.0,
            imageName: "product_cufflinks",
            category: "Accessories",
            rating: 4.7,
            reviewCount: 56,
            colors: ["Platinum"]
        ),
        Product(
            id: "5",
            name: "Raw Turquoise Cluster",
            shortDescription: "Uncut natural turquoise museum specimen",
            fullDescription: "A rare collector's piece. This large cluster of raw, uncut turquoise straight from the historic Neyshabur mines showcases the stone in its pure, natural state. Perfect for display in a luxury office or as an investment piece for future custom jewelry crafting.",
            price: 12500.0,
            discountedPrice: 11000.0,
            imageName: "product_raw",
            category: "Collectibles",
            rating: 5.0,
            reviewCount: 12,
            colors: ["Natural Earth", "Blue/Green"]
        ),
        Product(
            id: "6",
            name: "Gold Signet Turquoise",
            shortDescription: "Heavy 24K gold ring with flat turquoise",
            fullDescription: "A bold and commanding piece. Crafted from pure 24K gold, this heavy signet ring houses a perfectly flat, highly polished blue turquoise stone. The design is inspired by historical Persian merchant rings, symbolizing prosperity and trust.",
            price: 6800.0,
            discountedPrice: 6200.0,
            imageName: "product_signet",
            category: "Rings",
            rating: 4.6,
            reviewCount: 210,
            colors: ["Yellow Gold"]
        ),
        Product(
            id: "7",
            name: "Turquoise Rosary",
            shortDescription: "33-bead pure turquoise Misbaha",
            fullDescription: "A luxurious spiritual accessory. This 33-bead Misbaha (rosary) is crafted entirely from high-grade Neyshabur turquoise beads, separated by small gold dividers. A prestigious item highly valued by discerning clients in the Gulf countries.",
            price: 9500.0,
            discountedPrice: 8900.0,
            imageName: "product_rosary",
            category: "Accessories",
            rating: 4.9,
            reviewCount: 315,
            colors: ["Blue", "Gold"]
        ),
        Product(
            id: "8",
            name: "Diamond & Stone Bracelet",
            shortDescription: "White gold bracelet with diamonds and turquoise",
            fullDescription: "The perfect fusion of modern luxury and ancient beauty. This 18K white gold tennis-style bracelet alternates between flawless VVS diamonds and perfectly round-cut Neyshabur turquoise stones. Secure clasp and incredible brilliant shine.",
            price: 14500.0,
            discountedPrice: 13200.0,
            imageName: "product_bracelet",
            category: "Bracelets",
            rating: 4.8,
            reviewCount: 77,
            colors: ["White Gold"]
        )
    ]
}
