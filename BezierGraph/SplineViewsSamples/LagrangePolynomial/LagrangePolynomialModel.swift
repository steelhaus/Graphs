//
//  LagrangePolynomialModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import SwiftUI

final class LagrangePolynomialModel: CommonBezierSplineModel {

    private let stepsCount: Int = 100

    // Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 42, y: 317)),
            Point(position: CGPoint(x: 107, y: 223)),
            Point(position: CGPoint(x: 185, y: 346)),
            Point(position: CGPoint(x: 241, y: 243)),
            Point(position: CGPoint(x: 325, y: 131)),
            Point(position: CGPoint(x: 426, y: 286)),
            Point(position: CGPoint(x: 562, y: 204)),
            Point(position: CGPoint(x: 660, y: 278))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool, k: CGFloat) -> BridgesInfo {
        return .init(controlPoints: [], bridges: [])
    }

    func calculatePaths(points: [Point]) -> [PathInfo] {
        var path = Path()
        guard
            let minX = points.map(\.position.x).min(),
            let maxX = points.map(\.position.x).max(),
            let firstPoint = points.first?.position
        else { return [] }

        path.move(to: firstPoint)

        let step = (maxX - minX) / CGFloat(stepsCount)
        var currentX = minX + step

        while currentX <= maxX {
            let y = getLP(at: currentX, in: points)
            path.addLine(to: CGPoint(x: currentX, y: y))
            currentX += step
        }

        let lastPointY = getLP(at: maxX, in: points)
        path.addLine(to: CGPoint(x: maxX, y: lastPointY))

        return [PathInfo(style: .main, path: path)]
    }

    private func getLP(at x: CGFloat,
                       in points: [Point]) -> CGFloat {

        var f: CGFloat = 1
        var L: CGFloat = 0

        for i in 0 ..< points.count {
            f = 1
            for j in 0 ..< points.count {
                if j != i {
                    let xi = points[i].position.x
                    let xj = points[j].position.x
                    f *= (x - xj) / (xi - xj)
                }
            }
            f *= points[i].position.y
            L += f
        }

        return L
    }

}
