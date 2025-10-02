import SwiftData
import SwiftUI

struct GeometricPattern: View {
    var body: some View {
        Canvas { context, size in
            drawGeometricElements(context: context, size: size)
        }
    }
    
    private func drawGeometricElements(context: GraphicsContext, size: CGSize) {
        let gridSize: CGFloat = 40
        let cols = Int(size.width / gridSize) + 1
        let rows = Int(size.height / gridSize) + 1
        
        // Draw hexagons
        for row in 0..<rows {
            for col in 0..<cols {
                let x = CGFloat(col) * gridSize
                let y = CGFloat(row) * gridSize
                
                if (row + col) % 3 == 0 {
                    let hexPath = createHexagon(center: CGPoint(x: x, y: y), radius: 15)
                    context.stroke(hexPath, with: .color(.primary), lineWidth: 0.5)
                }
            }
        }
        
        // Draw diamonds
        for row in 0..<rows {
            for col in 0..<cols {
                let x = CGFloat(col) * gridSize
                let y = CGFloat(row) * gridSize
                
                if (row + col) % 4 == 0 {
                    let diamondPath = createDiamond(center: CGPoint(x: x + 20, y: y + 20), size: 8)
                    context.fill(diamondPath, with: .color(.secondary))
                }
            }
        }
        
        // Draw dots
        for row in 0..<rows {
            for col in 0..<cols {
                let x = CGFloat(col) * gridSize
                let y = CGFloat(row) * gridSize
                
                if (row * 3 + col * 2) % 7 == 0 {
                    let circle = Path(ellipseIn: CGRect(x: x + 10, y: y + 10, width: 3, height: 3))
                    context.fill(circle, with: .color(.gray))
                }
            }
        }
        
        // Draw flowing curves
        for i in 0..<5 {
            let curve = createFlowingCurve(in: size, offset: CGFloat(i) * 100)
            let strokeStyle = StrokeStyle(lineWidth: 1, lineCap: .round)
            context.stroke(curve, with: .color(.blue.opacity(0.3)), style: strokeStyle)
        }
    }
    
    private func createHexagon(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            for i in 0..<6 {
                let angle = CGFloat(i) * .pi / 3
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
    
    private func createDiamond(center: CGPoint, size: CGFloat) -> Path {
        Path { path in
            path.move(to: CGPoint(x: center.x, y: center.y - size))
            path.addLine(to: CGPoint(x: center.x + size, y: center.y))
            path.addLine(to: CGPoint(x: center.x, y: center.y + size))
            path.addLine(to: CGPoint(x: center.x - size, y: center.y))
            path.closeSubpath()
        }
    }
    
    private func createFlowingCurve(in size: CGSize, offset: CGFloat) -> Path {
        Path { path in
            let stepSize: CGFloat = 20
            let endPoint = size.width + stepSize
            let xValues = Array(stride(from: 0, to: endPoint, by: stepSize))
            
            var points: [CGPoint] = []
            for x in xValues {
                let baseY = size.height / 2
                let wave1 = sin(x / 30 + offset / 10) * 50
                let wave2 = cos(x / 60) * 30
                let finalY = baseY + wave1 + wave2
                
                let point = CGPoint(x: x, y: finalY)
                points.append(point)
            }
            
            guard let firstPoint = points.first else { return }
            path.move(to: firstPoint)
            
            for i in 1..<points.count {
                let currentPoint = points[i]
                let previousPoint = points[i-1]
                let midX = (currentPoint.x + previousPoint.x) / 2
                let midY = (currentPoint.y + previousPoint.y) / 2
                let midPoint = CGPoint(x: midX, y: midY)
                
                path.addQuadCurve(to: midPoint, control: previousPoint)
                path.addQuadCurve(to: currentPoint, control: midPoint)
            }
        }
    }
}

struct NoiseTexture: View {
    var body: some View {
        Canvas { context, size in
            drawNoisePattern(context: context, size: size)
        }
    }
    
    private func drawNoisePattern(context: GraphicsContext, size: CGSize) {
        for _ in 0..<1000 {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            let opacity = Double.random(in: 0.1...0.3)
            
            let dotRect = CGRect(x: x, y: y, width: 1, height: 1)
            let dotPath = Path(ellipseIn: dotRect)
            context.fill(dotPath, with: .color(.primary.opacity(opacity)))
        }
    }
}

#Preview("Pattern") {
    GeometricPattern()
}

#Preview("Noise") {
    GeometricPattern()
}
