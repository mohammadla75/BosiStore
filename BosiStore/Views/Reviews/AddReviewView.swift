//
//  AddReviewView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI
import PhotosUI

struct AddReviewView: View {
    let product: Product
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var localization: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @State private var rating: Int = 5
    @State private var comment: String = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoFileNames: [String] = []
    @State private var videoFileNames: [String] = []
    @State private var showCamera = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    ratingSection
                    commentSection
                    mediaSection
                    submitButton
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            Spacer()
            Text(localization.str("write_review"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 32, height: 32)
        }
    }
    
    private var ratingSection: some View {
        VStack(spacing: 12) {
            Text(localization.str("rating"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        withAnimation(.spring(response: 0.2)) { rating = star }
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 28))
                            .foregroundColor(.yellow)
                            .scaleEffect(star <= rating ? 1.1 : 1.0)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .glassCard(radius: 16)
    }
    
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(localization.str("reviews"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            TextEditor(text: $comment)
                .frame(minHeight: 120)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .foregroundColor(.white)
                .tint(.teal)
                .scrollContentBackground(.hidden)
        }
    }
    
    private var mediaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.str("add_photo"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 5,
                    matching: .images
                ) {
                    mediaButton(icon: "photo.fill", text: localization.str("add_photo"), color: .blue)
                }
                
                PhotosPicker(
                    selection: .constant([]),
                    maxSelectionCount: 2,
                    matching: .videos
                ) {
                    mediaButton(icon: "video.fill", text: localization.str("add_video"), color: .teal)
                }
            }
            
            if !photoFileNames.isEmpty {
                HStack {
                    ForEach(photoFileNames, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .foregroundColor(.blue)
                            )
                    }
                }
            }
        }
//        .onChange(of: selectedPhotos) { old, newItems in
//            Task {
//                var newFileNames: [String] = []
//                for item in old {
//                    if let data = try? await item.loadTransferable(type: Data.self) {
//                        let name = reviewManager.savePhoto(data: data)
//                        newFileNames.append(name)
//                    }
//                }
//                await MainActor.run {
//                    photoFileNames = newFileNames
//                }
//            }
//        }
    }
    
    private func mediaButton(icon: String, text: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassBackground(radius: 12)
    }
    
    private var submitButton: some View {
        Button {
            submitReview()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "paperplane.fill")
                Text(localization.str("submit_review"))
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [.teal, .cyan], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: .teal.opacity(0.4), radius: 15, x: 0, y: 8)
            )
        }
    }
    
    private func submitReview() {
        guard !comment.isEmpty else { return }
        
        let userName = authManager.currentUser?.fullName ?? "Anonymous"
        let userId = authManager.currentUser?.id ?? "guest"
        
        let review = Review(
            productId: product.id,
            userId: userId,
            userName: userName,
            rating: rating,
            comment: comment
        )
        
        reviewManager.addReview(review)
        dismiss()
    }
}
