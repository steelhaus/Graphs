//
//  SampleZeroModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 14.10.2021.
//

import SwiftUI

final class SampleZeroModel: CommonBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 33, y: 151)),
            Point(position: CGPoint(x: 126, y: 279)),
            Point(position: CGPoint(x: 237, y: 349)),
            Point(position: CGPoint(x: 305, y: 242)),
            Point(position: CGPoint(x: 375, y: 150)),
            Point(position: CGPoint(x: 463, y: 103)),
            Point(position: CGPoint(x: 557, y: 352)),
            Point(position: CGPoint(x: 650, y: 201))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    func calculateBridges(mainPoints: [Point],
                          controlPoints: [Point],
                          showControlPoints: Bool) -> BridgesInfo {
        var nextCP: CGPoint = mainPoints[0].position

        var mainBridges: [Bridge] = []
        var supportBridges: [Bridge] = []
        var controlPoints: [CGPoint] = []

        for i in 1 ..< mainPoints.count - 1 {
            let point = mainPoints[i]
            let lPoint = mainPoints[i - 1]
            let rPoint = mainPoints[i + 1]
            let cps = calculateMiddlePoint(point.position,
                                           lPoint: lPoint.position,
                                           rPoint: rPoint.position)
            let bridge = Bridge(style: .main,
                                type: .qubic(firstControlPoint: nextCP, secondControlPoint: cps.0),
                                startPoint: lPoint.position,
                                endPoint: point.position)
            mainBridges.append(bridge)
            if showControlPoints {
                supportBridges.append(.init(style: .support, type: .linear, startPoint: lPoint.position, endPoint: nextCP))
                supportBridges.append(.init(style: .support, type: .linear, startPoint: point.position, endPoint: cps.0))
                controlPoints.append(cps.0)
                controlPoints.append(cps.1)
            }
            nextCP = cps.1
        }

        let lastPoint = mainPoints[mainPoints.count - 1]
        let bridge = Bridge(style: .main,
                            type: .qubic(firstControlPoint: nextCP, secondControlPoint: lastPoint.position),
                            startPoint: mainPoints[mainPoints.count - 2].position,
                            endPoint: lastPoint.position)
        mainBridges.append(bridge)

        let cps = controlPoints.map { Point(style: .support, isDraggable: false, position: $0) }
        return .init(controlPoints: cps, bridges: mainBridges + supportBridges)
    }

    /// Здесь этот метод не нужен
    func calculatePaths(points: [Point]) -> [PathInfo] { [] }

    private func calculateMiddlePoint(_ point: CGPoint, lPoint: CGPoint, rPoint: CGPoint) -> (CGPoint, CGPoint) {
        
        let dxMultiplier: CGFloat = 0.15
        let kCoeff = (rPoint.y - lPoint.y) / (rPoint.x - lPoint.x)
        let bCoeff = point.y - kCoeff * point.x
        let deltaX = min(point.x - lPoint.x, rPoint.x - point.x) * dxMultiplier
        let cp1X = point.x - deltaX
        let cp1Y = kCoeff * cp1X + bCoeff
        let cp2X = point.x + deltaX
        let cp2Y = kCoeff * cp2X + bCoeff
        return (CGPoint(x: cp1X, y: cp1Y), CGPoint(x: cp2X, y: cp2Y))
    }
}

