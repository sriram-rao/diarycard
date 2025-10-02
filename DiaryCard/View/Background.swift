//
//  Background.swift
//  diarycard
//
//  Created by Sriram Rao on 9/25/25.
//

import SwiftUI

struct Background: View {
    var body: some View {
            ZStack {
                // Base gradient
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(.systemBlue).opacity(0.1), location: 0.0),
                        .init(color: Color(.systemPurple).opacity(0.05), location: 0.3),
                        .init(color: Color(.systemTeal).opacity(0.08), location: 0.7),
                        .init(color: Color(.systemIndigo).opacity(0.12), location: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Geometric pattern overlay
                GeometricPattern()
                    .opacity(0.3)
                
                // Subtle noise texture
                NoiseTexture()
                    .opacity(1.0)
                    .blendMode(.overlay)
            }
            .edgesIgnoringSafeArea(.all)
            .zIndex(-1)
    }
}


#Preview {
    Background()
}
