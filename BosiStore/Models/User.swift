//
//  User.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String
    var fullName: String
    var email: String
    var phone: String
    var password: String
    var addresses: [UserAddress]
    var profileImage: String?
    
    init(
        id: String = UUID().uuidString,
        fullName: String,
        email: String,
        phone: String,
        password: String,
        addresses: [UserAddress] = [],
        profileImage: String? = nil
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.password = password
        self.addresses = addresses
        self.profileImage = profileImage
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

