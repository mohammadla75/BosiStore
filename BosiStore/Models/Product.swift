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
            name: "AirPods Pro Max",
            shortDescription: "Wireless headphones with Active Noise Cancellation",
            fullDescription: "Experience extraordinary sound quality with AirPods Pro Max. Featuring Active Noise Cancellation, Transparency mode, Spatial Audio with dynamic head tracking, and up to 20 hours of battery life. The aluminum body with memory foam ear cushions delivers maximum comfort for extended listening sessions. The H2 chip provides computational audio processing for an immersive experience.",
            price: 549.0,
            discountedPrice: 449.0,
            imageName: "headphones",
            category: "Audio",
            rating: 4.8,
            reviewCount: 2340,
            colors: ["Silver", "Space Gray", "Sky Blue", "Pink", "Green"]
        ),
        Product(
            id: "2",
            name: "MacBook Pro 16\"",
            shortDescription: "Professional laptop with M3 Pro chip",
            fullDescription: "The most powerful MacBook ever. MacBook Pro 16-inch with M3 Pro chip features a Liquid Retina XDR display, up to 22 hours of battery life, 36GB unified memory, and 1TB SSD storage. Perfect for video editing, software development, 3D rendering, and graphic design. The new design includes an HDMI port, SD card slot, MagSafe charging, and three Thunderbolt 4 ports.",
            price: 2499.0,
            discountedPrice: 2199.0,
            imageName: "laptopcomputer",
            category: "Computers",
            rating: 4.9,
            reviewCount: 1567,
            colors: ["Silver", "Space Black"]
        ),
        Product(
            id: "3",
            name: "iPhone 16 Pro",
            shortDescription: "Smartphone with 48MP camera system",
            fullDescription: "iPhone 16 Pro features the A18 Pro chip, a 48MP triple camera system, an Always-On Super Retina XDR display at 6.3 inches, and a titanium body. Capture stunning 4K video at 120fps, customize the Action button, and enjoy all-day battery life. The new Camera Control button gives you instant access to your camera with haptic feedback.",
            price: 1199.0,
            discountedPrice: 999.0,
            imageName: "iphone",
            category: "Mobile",
            rating: 4.7,
            reviewCount: 5621,
            colors: ["Natural Titanium", "Blue Titanium", "White Titanium", "Black Titanium"]
        ),
        Product(
            id: "4",
            name: "Apple Watch Ultra 2",
            shortDescription: "Rugged smartwatch for adventurers",
            fullDescription: "Apple Watch Ultra 2 with a 49mm titanium case, 3000-nit display, precision dual-frequency GPS, and water resistance up to 100 meters. Built for diving, hiking, and extreme sports. Features up to 36 hours of battery life in normal mode, 72 hours in low power mode. The customizable Action button provides instant access to your favorite features.",
            price: 799.0,
            discountedPrice: 699.0,
            imageName: "applewatch",
            category: "Wearable",
            rating: 4.6,
            reviewCount: 987,
            colors: ["Natural Titanium", "Black Titanium"]
        ),
        Product(
            id: "5",
            name: "iPad Pro 13\"",
            shortDescription: "Professional tablet with tandem OLED display",
            fullDescription: "iPad Pro 13-inch with Ultra Retina XDR tandem OLED display, M4 chip, Apple Pencil Pro support, and Magic Keyboard compatibility. 2TB storage, TrueDepth camera with Face ID, and Thunderbolt connectivity. The thinnest Apple product ever made. Perfect for creative professionals, digital artists, and content creators.",
            price: 1299.0,
            discountedPrice: 1099.0,
            imageName: "ipad",
            category: "Tablets",
            rating: 4.8,
            reviewCount: 2103,
            colors: ["Silver", "Space Black"]
        ),
        Product(
            id: "6",
            name: "HomePod 2nd Gen",
            shortDescription: "Smart speaker with room-filling sound",
            fullDescription: "HomePod delivers high-fidelity audio with deep bass and crystal-clear highs. Features Spatial Audio with Dolby Atmos, room sensing technology, Siri integration, HomeKit hub functionality, temperature and humidity sensor. Connect two for stereo pair. The S7 chip with software-modeled tuning delivers computational audio for an immersive sound experience.",
            price: 299.0,
            discountedPrice: 249.0,
            imageName: "hifispeaker",
            category: "Audio",
            rating: 4.5,
            reviewCount: 1456,
            colors: ["Midnight", "White"]
        ),
        Product(
            id: "7",
            name: "Vision Pro",
            shortDescription: "Spatial computing headset",
            fullDescription: "Apple Vision Pro introduces spatial computing with a revolutionary 3D interface. Features dual micro-OLED displays with 23 million pixels, M2 and R1 chips, eye tracking, hand tracking, and voice input. Transform any space into your personal theater, workspace, or gaming arena. The most advanced personal electronics device ever created.",
            price: 3499.0,
            discountedPrice: 3299.0,
            imageName: "visionpro",
            category: "Wearable",
            rating: 4.4,
            reviewCount: 654,
            colors: ["Silver"]
        ),
        Product(
            id: "8",
            name: "Magic Keyboard Pro",
            shortDescription: "Wireless keyboard with Touch ID",
            fullDescription: "Magic Keyboard Pro features a wireless design, integrated Touch ID sensor, comfortable low-profile keys, one-month rechargeable battery, and Bluetooth connectivity. Compatible with all Apple devices. Experience smooth and quiet typing with scissor mechanism keys. The full-size layout includes function keys and a numeric keypad.",
            price: 199.0,
            discountedPrice: 169.0,
            imageName: "keyboard",
            category: "Accessories",
            rating: 4.3,
            reviewCount: 1890,
            colors: ["White", "Black"]
        )
    ]
}
