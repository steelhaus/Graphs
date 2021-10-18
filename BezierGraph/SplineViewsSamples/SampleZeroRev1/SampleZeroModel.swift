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

    var shouldShowKSelector: Bool { true }

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
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo {

        let mainPoints = mainPoints + [mainPoints[mainPoints.count - 1]]
        var containers: [QuibicBridgeContainer] = []
        var controlPoints: [Point] = []
        let points = mainPoints.map(\.position)

        guard let firstPoint = points.first else { return .init(controlPoints: [], bridges: []) }
        var leftControlPoint: CGPoint = firstPoint
        for i in 0 ..< mainPoints.count - 2 {
            // Алгоритм расчета контрольных точек
            let controlPointsTuple = calculateMiddlePoint(points[i + 1],
                                                     lPoint: points[i],
                                                     rPoint: points[i + 2],
                                                     curvingCoeff: k)
            let rightControlPoint = controlPointsTuple.0

            // Добавим точки и кривые для отображения
            let cp1 = Point(style: .support, isDraggable: false, position: leftControlPoint)
            let cp2 = Point(style: .support, isDraggable: false, position: rightControlPoint)
            let container = QuibicBridgeContainer(mp1: mainPoints[i],
                                                  mp2: mainPoints[i + 1],
                                                  cp1: cp1,
                                                  cp2: cp2)
            controlPoints.append(contentsOf: [cp1, cp2])
            containers.append(container)
            leftControlPoint = controlPointsTuple.1
        }

        // Далее все для отображения. Формируем кривые, каждая на основе двух точек и двух контрольных точек

        // Main bridges
        var bridges = containers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = containers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }

    /// Здесь этот метод не нужен
    func calculatePaths(points: [Point]) -> [PathInfo] { [] }

    private func calculateMiddlePoint(_ point: CGPoint, lPoint: CGPoint, rPoint: CGPoint, curvingCoeff: CGFloat) -> (CGPoint, CGPoint) {
        
        let dxMultiplier: CGFloat = curvingCoeff
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

