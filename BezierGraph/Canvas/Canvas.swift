//
//  Canvas.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

struct Canvas: View {
    let points: [Point]
    let bridges: [Bridge]
    var paths: [PathInfo] = []
    let pointsScale: CGFloat
    let onPointDrag: ((Point, CGPoint) -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .strokeBorder(Color.black, lineWidth: 2.0)
            ForEach(bridges) { bridge in
                if let bezierPath = makeBezierPathFromBridge(bridge) {
                    bezierPath
                        .stroke(bridge.color, lineWidth: bridge.lineWidth)
                }
            }
            ForEach(paths) { path in
                path.path
                    .stroke(path.color, lineWidth: path.lineWidth)
            }
            ForEach(points) { point in
                let pointSize = point.sizeWithScale(pointsScale)
                Circle()
                    .fill(point.color)
                    .frame(width: pointSize, height: pointSize)
                    .position(x: point.position.x, y: point.position.y)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged() { value in
                                guard point.isDraggable else { return }
                                onPointDrag?(point, value.location)
                            }
                    )
            }
        }
    }

    private func makeBezierPathFromBridge(_ bridge: Bridge) -> Path? {
        let path = UIBezierPath()
        path.move(to: bridge.startPoint)

        switch bridge.type {
            case .linear:
                path.addLine(to: bridge.endPoint)
            case let .quadratic(controlPoint):
                path.addQuadCurve(to: bridge.endPoint,
                                  controlPoint: controlPoint)
            case let .qubic(firstControlPoint, secondControlPoint):
                path.addCurve(to: bridge.endPoint,
                              controlPoint1: firstControlPoint,
                              controlPoint2: secondControlPoint)
        }
        return Path(path.cgPath)
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        let point1 = Point(position: .init(x: 50, y: 50))
        let point2  = Point(position: .init(x: 100, y: 100))
        let controlPoint = Point(style: .support, position: .init(x: 100, y: 50))
        let mainBridge = Bridge(style: .main,
                                type: .quadratic(controlPoint: controlPoint.position),
                                startPoint: point1.position,
                                endPoint: point2.position)
        let controlBridge1 = Bridge(style: .support,
                                    type: .linear,
                                    startPoint: point1.position,
                                    endPoint: controlPoint.position)
        let controlBridge2 = Bridge(style: .support,
                                    type: .linear,
                                    startPoint: point2.position,
                                    endPoint: controlPoint.position)
        Canvas(points: [point1, point2, controlPoint],
               bridges: [mainBridge, controlBridge1, controlBridge2],
               pointsScale: 1.0,
               onPointDrag: nil)
    }
}
