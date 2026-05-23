//
//  ReviewListView.swift
//  BosiStore
//
//  Created by MAC on 3/2/1405 AP.
//

import Foundation
import SwiftUI

struct ReviewListView: View {
    let product: Product
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var showAddReview = false
    
    var productReviews: [Review] {
        reviewManager.reviews.filter { $0.productId == product.id }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 16) {
                header
                
                if productReviews.isEmpty {
                    Spacer()
                    emptyState
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(productReviews) { review in
                                reviewRow(review)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewView(product: product)
                .environmentObject(authManager)
                .environmentObject(reviewManager)
                .environmentObject(localization)
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
            Text(localization.str("reviews"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Button { showAddReview = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle().fill(LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "message")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            Text(localization.str("no_reviews"))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            Text(localization.str("first_review"))
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
    
    private func reviewRow(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Text(String(review.userName.prefix(1)))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.userName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(review.date, style: .date)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < review.rating ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            Text(review.comment)
                .font(.system(size: 13))
                .foregroundColor(.gray.opacity(0.9))
                .lineSpacing(4)
            
//            if let photos = review.photoFileNames, !photos.isEmpty,
//               let videos = review.videoFileNames {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 8) {
//                        ForEach(photos, id: \.self) { _ in
//                            mediaThumb(icon: "photo.fill", color: .blue)
//                        }
//                        ForEach(videos, id: \.self) { _ in
//                            mediaThumb(icon: "video.fill", color: .purple)
//                        }
//                    }
//                }
//            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(radius: 14)
    }
    
    private func mediaThumb(icon: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.opacity(0.2))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            )
    }
}
