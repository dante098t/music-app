//
//  PremiumView.swift
//  doan_nhom6
//
//  Created by macbook on 12/5/26.
//

import Foundation
import SwiftUI

struct PremiumView: View {

    @Binding var isPresented: Bool

    @State private var animateCards = false
    @State private var selected: PremiumPlan?

    var body: some View {

        ZStack {

            // MARK: Background (giống banner nhưng mạnh hơn)
            LinearGradient(
                colors: [
                    .purple.opacity(0.9),
                    .pink.opacity(0.9),
                    .red.opacity(0.8),
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: Header
                HStack {

                    Button {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("Premium Plans")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 24, height: 24)
                }
                .padding()

                Spacer()

                // MARK: Cards
                VStack(spacing: 18) {

                    PremiumCard(
                        title: "Student",
                        price: "$2.99",
                        features: [
                            "Ad-free music",
                            "Offline mode",
                            "1 device"
                        ],
                        isSelected: selected == .student
                    ) {
                        select(.student)
                    }

                    PremiumCard(
                        title: "Individual",
                        price: "$5.99",
                        features: [
                            "Ad-free music",
                            "Offline mode",
                            "High quality audio"
                        ],
                        isSelected: selected == .individual
                    ) {
                        select(.individual)
                    }

                    PremiumCard(
                        title: "Family",
                        price: "$9.99",
                        features: [
                            "Up to 6 accounts",
                            "Parental control",
                            "Offline mode"
                        ],
                        isSelected: selected == .family
                    ) {
                        select(.family)
                    }
                }
                .scaleEffect(animateCards ? 1 : 0.6)
                .opacity(animateCards ? 1 : 0)
                .rotation3DEffect(
                    .degrees(animateCards ? 0 : 35),
                    axis: (x: 1, y: 0, z: 0)
                )
                .animation(.spring(response: 0.7, dampingFraction: 0.85), value: animateCards)

                Spacer()

                // MARK: CTA
                Button {

                } label: {

                    Text("Continue")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                }
                .opacity(selected == nil ? 0.4 : 1)
                .disabled(selected == nil)

                Spacer(minLength: 20)
            }
        }
        .onAppear {
            animateCards = true
        }
    }

    func select(_ plan: PremiumPlan) {
        withAnimation(.spring()) {
            selected = plan
        }
    }
}

enum PremiumPlan {
    case student, individual, family
}

struct PremiumCard: View {

    let title: String
    let price: String
    let features: [String]
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {

        ZStack {

            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.15),
                            .white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 12)

            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    Spacer()

                    Text(price)
                        .font(.headline)
                        .foregroundColor(.white)
                }

                ForEach(features, id: \.self) { f in
                    Text("• \(f)")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                }
            }
            .padding()
        }
        .frame(height: 120)
        .padding(.horizontal)
        .scaleEffect(isSelected ? 1.05 : 1)
        .animation(.spring(), value: isSelected)
        .onTapGesture {
            onTap()
        }
    }
}
