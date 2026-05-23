//
//  Address.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
struct UserAddress: Codable, Identifiable, Equatable {
    var id: String
    var title: String
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var latitude: Double?
    var longitude: Double?
    var isDefault: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        street: String,
        city: String,
        state: String,
        zipCode: String,
        country: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        isDefault: Bool = false
    ) {
        self.id = id
        self.title = street
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.isDefault = isDefault
    }
}
