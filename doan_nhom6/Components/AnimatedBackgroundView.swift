//
//  AnimatedBackgroundView.swift
//  doan_nhom6
//
//  Created by macbook on 11/5/26.
//

import Foundation
import SwiftUI
struct AnimatedBackgroundView: View {

    @State private var animate = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color.black,
                    Color.white.opacity(0.9),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 350)
                .blur(radius: 90)
                .offset(
                    x: animate ? -120 : 120,
                    y: animate ? -300 : -150
                )

            Circle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(
                    x: animate ? 140 : -140,
                    y: animate ? 250 : 80
                )

            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 250)
                .blur(radius: 90)
                .offset(
                    x: animate ? -100 : 100,
                    y: animate ? 300 : 100
                )

            // Floating Stars

            ForEach(0..<40, id: \.self) { _ in

                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(
                        width: CGFloat.random(in: 2...5),
                        height: CGFloat.random(in: 2...5)
                    )
                    .offset(
                        x: CGFloat.random(in: -220...220),
                        y: CGFloat.random(in: -450...450)
                    )
                    .opacity(animate ? 0.2 : 1)
                    .animation(
                        .easeInOut(
                            duration: Double.random(in: 2...6)
                        )
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
            }
        }
        .onAppear {

            withAnimation(
                .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
            ) {
                animate.toggle()
            }
        }
    }
}


