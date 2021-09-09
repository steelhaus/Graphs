//
//  QubicSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import SwiftUI

final class QubicSplineModel: CommonBezierSplineModel {

    private let stepsCount: Int = 100

    // Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 43, y: 162)),
            Point(position: CGPoint(x: 120, y: 292)),
            Point(position: CGPoint(x: 258, y: 251)),
            Point(position: CGPoint(x: 343, y: 79)),
            Point(position: CGPoint(x: 406, y: 224)),
            Point(position: CGPoint(x: 472, y: 424)),
            Point(position: CGPoint(x: 596, y: 74)),
            Point(position: CGPoint(x: 696, y: 231))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool) -> BridgesInfo {
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

        let splineInfo = buildSpline(points: points)

        let step = (maxX - minX) / CGFloat(stepsCount)
        var currentX = minX + step

        while currentX <= maxX {
            let y = funcInterp(x: currentX, splines: splineInfo)
            path.addLine(to: CGPoint(x: currentX, y: y))
            currentX += step
        }

        let lastPointY = funcInterp(x: maxX, splines: splineInfo)
        path.addLine(to: CGPoint(x: maxX, y: lastPointY))

        return [PathInfo(style: .main, path: path)]
    }

    struct CSplineInfo {
        var x: CGFloat = 0
        var a: CGFloat = 0
        var b: CGFloat = 0
        var c: CGFloat = 0
        var d: CGFloat = 0
    }

    private func buildSpline(points: [Point]) -> [CSplineInfo] {
        let x = points.map(\.position.x)
        let y = points.map(\.position.y)
        let n = points.count

        var alpha: [CGFloat] = Array(repeating: 0, count: n)
        var beta: [CGFloat] = Array(repeating: 0, count: n)

        var splines: [CSplineInfo] = []
        for i in 0 ..< points.count {
            splines.append(CSplineInfo(x: x[i], a: y[i], b: 0, c: 0, d: 0))
        }
        splines[0].c = 0
        splines[points.count - 1].c = 0

        for i in 1 ..< points.count - 1 {
            let h_i = x[i] - x[i - 1]
            let h_i1 = x[i + 1] - x[i]
            let a = h_i
            let b = h_i1
            let c = 2.0 * (h_i + h_i1)
            let f = 6.0 * ((y[i + 1] - y[i]) / h_i1 - (y[i] - y[i - 1]) / h_i)
            let z = (a * alpha[i - 1] + c)
            alpha[i] = -b / z
            beta[i] = (f - a * beta[i - 1]) / z
        }

        var i = n - 2
        while i > 0 {
            splines[i].c = alpha[i] * splines[i + 1].c + beta[i]
            i -= 1
        }

        i = n - 1
        while i > 0 {
            let h_i = x[i] - x[i - 1]
            splines[i].d = (splines[i].c - splines[i - 1].c) / h_i
            let temp = h_i * (2.0 * splines[i].c + splines[i - 1].c) / 6.0
            splines[i].b = temp + (y[i] - y[i - 1]) / h_i
            i -= 1
        }

        return splines
    }

    private func funcInterp(x: CGFloat, splines: [CSplineInfo]) -> CGFloat {
        let n = splines.count
        var s: CSplineInfo
        if x <= splines[0].x {
            s = splines[1]
        } else if x >= splines[n - 1].x {
            s = splines[n - 1]
        } else {
            var i = 0
            var j = n - 1
            while i + 1 < j {
                let k = i + (j - i) / 2
                if x <= splines[k].x {
                    j = k
                } else {
                    i = k
                }
            }
            s = splines[j]
        }
        let dx = x - s.x
        return s.a + (s.b + (s.c / 2.0 + s.d * dx / 6.0) * dx) * dx;
    }
}
