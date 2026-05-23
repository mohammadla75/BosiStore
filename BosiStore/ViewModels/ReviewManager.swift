//
//  ReviewManager.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI
internal import Combine

final class ReviewManager: ObservableObject {
    @Published var reviews: [Review] = []
    
    private let reviewsKey = "stored_reviews_data"
    
    init() {
        loadReviews()
    }
    
    // MARK: - Public Methods
    
    func addReview(_ review: Review) {
        reviews.append(review)
        saveReviews()
    }
    
    func deleteReview(id: String) {
        reviews.removeAll { $0.id == id }
        saveReviews()
    }
    
    func reviewsForProduct(_ productId: String) -> [Review] {
        reviews.filter { $0.productId == productId }
    }
    
    func reviewCountForProduct(_ productId: String) -> Int {
        reviewsForProduct(productId).count
    }
    
    func averageRating(for productId: String) -> Double {
        let productReviews = reviewsForProduct(productId)
        guard !productReviews.isEmpty else { return 0.0 }
        let total = productReviews.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(productReviews.count)
    }
    
    // MARK: - Media Management
    
    func saveMediaLocally(data: Data, type: MediaType) -> String {
        let fileName: String
        switch type {
        case .photo:
            fileName = "\(UUID().uuidString).jpg"
        case .video:
            fileName = "\(UUID().uuidString).mp4"
        }
        
        let documentsDirectory = getDocumentsDirectory()
        let mediaDirectory = documentsDirectory.appendingPathComponent("ReviewMedia", isDirectory: true)
        
        // Create directory if needed
        if !FileManager.default.fileExists(atPath: mediaDirectory.path) {
            try? FileManager.default.createDirectory(at: mediaDirectory, withIntermediateDirectories: true)
        }
        
        let fileURL = mediaDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to save media: \(error.localizedDescription)")
        }
        
        return fileName
    }
    
    func loadMediaData(from fileName: String) -> Data? {
        let documentsDirectory = getDocumentsDirectory()
        let fileURL = documentsDirectory
            .appendingPathComponent("ReviewMedia")
            .appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
    
    func deleteMedia(fileName: String) {
        let documentsDirectory = getDocumentsDirectory()
        let fileURL = documentsDirectory
            .appendingPathComponent("ReviewMedia")
            .appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    // MARK: - Private Methods
    
    private func saveReviews() {
        do {
            let data = try JSONEncoder().encode(reviews)
            UserDefaults.standard.set(data, forKey: reviewsKey)
        } catch {
            print("Failed to save reviews: \(error.localizedDescription)")
        }
    }
    
    private func loadReviews() {
        guard let data = UserDefaults.standard.data(forKey: reviewsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([Review].self, from: data)
            self.reviews = decoded
        } catch {
            print("Failed to load reviews: \(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
