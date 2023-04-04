//
//  ShapesUIView.swift
//  SwiftUITests
//
//  Created by Andre Luiz Carlota on 1/17/23.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20

    // How wide to make each petal
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()

        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)

            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))

            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)

            // add it to our main path
            path.addPath(rotatedPetal)
        }

        // now send the main path back
        return path
    }
}

struct ShapesUIView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        ScrollView {
            VStack {
                Text("Offset")
                    .hidden()
                    .navigationTitle("Shapes")

                Arc(startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
                    .stroke(.green, lineWidth: 10)
                        .frame(width: 300, height: 300)

                Triangle()
                    .stroke(.red, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 200)
                    .padding([.bottom])


                VStack {
                    Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                        .fill(.blue, style: FillStyle(eoFill: true))
                        .padding([.bottom])


                    Text("Offset")
                    Slider(value: $petalOffset, in: -40...40)
                        .padding([.horizontal, .bottom])

                    Text("Width")
                    Slider(value: $petalWidth, in: 0...100)
                        .padding(.horizontal)
                }.frame(width: .infinity , height: 600)

            }
        }
    }
}

struct ShapesUIView_Previews: PreviewProvider {
    static var previews: some View {
        ShapesUIView()
    }
}