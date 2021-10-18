//
//  CatmullRomBezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import SwiftUI

final class CatmullRomBezierSplineModel: CommonBezierSplineModel {

    private let stepsCount: Int = 100

    // Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 33, y: 151)),
            Point(position: CGPoint(x: 126, y: 279)),
            Point(position: CGPoint(x: 237, y: 349)),
            Point(position: CGPoint(x: 305, y: 242)),
            Point(position: CGPoint(x: 375, y: 150)),
            Point(position: CGPoint(x: 463, y: 103)),
            Point(position: CGPoint(x: 557, y: 352)),
            Point(position: CGPoint(x: 668, y: 201))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool, k: CGFloat) -> BridgesInfo {

        let mainPoints = mainPoints + [mainPoints[mainPoints.count - 1]]
        var containers: [QuibicBridgeContainer] = []
        var controlPoints: [Point] = []
        let points = mainPoints.map(\.position)

        var dl: CGFloat = 0
        let k: CGFloat = 0.6
        for i in 0 ..< points.count - 2 {
            let dr = (points[i + 2].y - points[i].y) / 2 * k
            let cp1Position = CGPoint(x: points[i].x + k * 30, y: points[i].y + dl)
            let cp2Position = CGPoint(x: points[i + 1].x - k * 30, y: points[i + 1].y - dr)
            let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
            let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
            let container = QuibicBridgeContainer(mp1: mainPoints[i],
                                                  mp2: mainPoints[i + 1],
                                                  cp1: cp1,
                                                  cp2: cp2)
            controlPoints.append(contentsOf: [cp1, cp2])
            containers.append(container)
            dl = dr
        }

        // Main bridges
        var bridges = containers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = containers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }

    func calculatePaths(points: [Point]) -> [PathInfo] {
        let points = points.map(\.position) + [points[points.count - 1].position]

        var path = Path()
        path.move(to: points[0])
        let step = 1 / CGFloat(stepsCount)

        var dl: CGFloat = 0
        for i in 0 ..< points.count - 2 {
            let dr = (points[i + 2].y - points[i].y) / 2
            let a3 = dl + dr + 2.0 * (points[i].y - points[i + 1].y)
            let a2 = points[i + 1].y - a3 - dl - points[i].y

            var t: CGFloat = 0
            while t <= 1 {
                var y = a3
                y = y * t + a2
                y = y * t + dl
                y = y * t + points[i].y
                let dx = points[i + 1].x - points[i].x
                path.addLine(to: CGPoint(x: points[i].x + t * dx, y: y))
                t += step
            }
            dl = dr
        }
        return [PathInfo(style: .custom(color: .gray, lineWidth: 0.5), path: path)]
    }
}
