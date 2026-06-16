import Foundation
import SwiftUI
internal import Combine

final class AuthManager: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isAuthenticated: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let usersKey = "stored_users_data"
    private let sessionKey = "current_user_session"
    
    init() {
        loadSession()
        setupTestAccount() // Ensure test account is created on app launch
    }
    
    // MARK: - Register
    
    func register(fullName: String, email: String, phone: String, password: String, confirmPassword: String) -> Bool {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !phone.isEmpty else {
            alertMessage = "fill_all_fields"
            showAlert = true
            return false
        }
        
        guard password == confirmPassword else {
            alertMessage = "password_mismatch"
            showAlert = true
            return false
        }
        
        // Check if email already exists
        let existingUsers = loadAllUsers()
        if existingUsers.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            alertMessage = "email_already_exists"
            showAlert = true
            return false
        }
        
        let newUser = User(
            fullName: fullName,
            email: email.lowercased(),
            phone: phone,
            password: password
        )
        
        var users = existingUsers
        users.append(newUser)
        saveAllUsers(users)
        
        alertMessage = "registration_success"
        showAlert = true
        return true
    }
    
    // MARK: - Login
    
    func login(email: String, password: String) -> Bool {
        let users = loadAllUsers()
        
        guard let user = users.first(where: {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }) else {
            alertMessage = "invalid_credentials"
            showAlert = true
            return false
        }
        
        currentUser = user
        isAuthenticated = true
        saveSession(userId: user.id)
        return true
    }
    
    // MARK: - Logout
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }
    
    // MARK: - Address Management
    
    func addAddress(_ address: UserAddress) {
        guard var user = currentUser else { return }
        user.addresses.append(address)
        currentUser = user
        updateStoredUser(user)
    }
    
    func removeAddress(at index: Int) {
        guard var user = currentUser else { return }
        guard index < user.addresses.count else { return }
        user.addresses.remove(at: index)
        currentUser = user
        updateStoredUser(user)
    }
    
    func updateAddress(_ address: UserAddress) {
        guard var user = currentUser else { return }
        if let index = user.addresses.firstIndex(where: { $0.id == address.id }) {
            user.addresses[index] = address
            currentUser = user
            updateStoredUser(user)
        }
    }
    
    // MARK: - Profile Update
    
    func updateProfile(fullName: String, phone: String) {
        guard var user = currentUser else { return }
        user.fullName = fullName
        user.phone = phone
        currentUser = user
        updateStoredUser(user)
    }
    
    // MARK: - Delete Account (New)
    
    func deleteAccount() {
        guard let current = currentUser else { return }
        
        var users = loadAllUsers()
        // Remove the current user from the local database
        users.removeAll { $0.id == current.id }
        saveAllUsers(users)
        
        // Log the user out completely
        logout()
    }
    
    // MARK: - Private Persistence Methods
    
    private func saveAllUsers(_ users: [User]) {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: usersKey)
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    private func loadAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else {
            return []
        }
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
            return []
        }
    }
    
    private func updateStoredUser(_ user: User) {
        var users = loadAllUsers()
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            saveAllUsers(users)
        }
    }
    
    private func saveSession(userId: String) {
        UserDefaults.standard.set(userId, forKey: sessionKey)
    }
    
    private func loadSession() {
        guard let userId = UserDefaults.standard.string(forKey: sessionKey) else { return }
        let users = loadAllUsers()
        if let user = users.first(where: { $0.id == userId }) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    // MARK: - Test Account Setup (New)
    
    private func setupTestAccount() {
        let testEmail = "test@test.com"
        var users = loadAllUsers()
        
        // Create the test account if it does not exist already
        if !users.contains(where: { $0.email.lowercased() == testEmail }) {
            let testUser = User(
                fullName: "Descusr",
                email: testEmail,
                phone: "1234567890",
                password: "123"
            )
            users.append(testUser)
            saveAllUsers(users)
        }
    }
}
