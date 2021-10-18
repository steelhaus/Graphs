//
//  ApprozimationSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import SwiftUI

final class ApproximationSplineModel: CommonBezierSplineModel {

    private let stepsCount: Int = 100

    // Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 37, y: 94)),
            Point(position: CGPoint(x: 185, y: 119)),
            Point(position: CGPoint(x: 282, y: 258)),
            Point(position: CGPoint(x: 386, y: 179)),
            Point(position: CGPoint(x: 470, y: 316)),
            Point(position: CGPoint(x: 544, y: 131)),
            Point(position: CGPoint(x: 626, y: 219)),
            Point(position: CGPoint(x: 701, y: 113))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool, k: CGFloat) -> BridgesInfo {
        return .init(controlPoints: [], bridges: [])
    }

    func calculatePaths(points: [Point]) -> [PathInfo] {
        let resultPoints = getApproximatedPoints(points: points)
        guard let firstPoint = resultPoints.first else { return [] }

        var path = Path()
        path.move(to: firstPoint)
        for i in 1 ..< resultPoints.count {
            path.addLine(to: resultPoints[i])
        }
        return [PathInfo(style: .main, path: path)]
    }

    // MARK: - Calculations

    private var factorialLookup: [Int: CGFloat] = [:]

    private func factorial(_ n: Int) -> CGFloat {
        if n == 0 { return 1 }

        if let currentValue = factorialLookup[n] {
            return currentValue
        }

        let value = (1...n).map(CGFloat.init).reduce(1.0, *)
        factorialLookup[n] = value
        return value
    }

    private func bernsteinBasis(n: Int, i: Int, t: CGFloat) -> CGFloat {
        let ti = t == 0 && i == 0 ? 1.0 : pow(t, CGFloat(i))
        let tni = n == i && t == 1 ? 1.0 : pow((1 - t), CGFloat(n - i))
        return (factorial(n) / (factorial(i) * factorial(n - i))) * ti * tni
    }

    private func getApproximatedPoints(points: [Point]) -> [CGPoint] {
        var result: [CGPoint] = []
        var t: CGFloat = 0
        let step = 1.0 / CGFloat(stepsCount - 1)

        for _ in 0 ..< stepsCount {
            if 1.0 - t < 5e-6 {
                t = 1
            }
            var x: CGFloat = 0
            var y: CGFloat = 0
            for i in 0 ..< points.count {
                let basis = bernsteinBasis(n: points.count - 1, i: i, t: t)
                x += basis * points[i].position.x
                y += basis * points[i].position.y
            }
            let point = CGPoint(x: x, y: y)
            result.append(point)
            t += step
        }

        return result
    }
}
