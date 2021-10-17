//
//  SampleZeroRev2Model.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 17.10.2021.
//

import SwiftUI

final class SampleZeroRev2Model: CommonBezierSplineModel {

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
    ///   - controlPoints: Контрольные точки (здесь не используются)
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    func calculateBridges(mainPoints: [Point],
                          controlPoints: [Point],
                          showControlPoints: Bool) -> BridgesInfo {

        // Для рассчетов добавим одну дополнительную точку, эквивалентную последней
        let mainPoints = mainPoints + [mainPoints[mainPoints.count - 1]]
        var containers: [QuibicBridgeContainer] = []
        var controlPoints: [Point] = []
        let points = mainPoints.map(\.position)

        var leftDeltaY: CGFloat = 0
        var leftDeltaX: CGFloat = 0
        let roundingCoefficient: CGFloat = 0.15
        for i in 0 ..< points.count - 2 {
            // Алгоритм рассчета контрольных точек
            let rightDeltaY = (points[i + 2].y - points[i].y) / 2 * roundingCoefficient
            let rightDeltaX = (points[i + 1].x - points[i].x) * roundingCoefficient
            let leftControlPoint = CGPoint(x: points[i].x + leftDeltaX,
                                           y: points[i].y + leftDeltaY)
            let rightControlPoint = CGPoint(x: points[i + 1].x - rightDeltaX,
                                            y: points[i + 1].y - rightDeltaY)
            leftDeltaX = rightDeltaX
            leftDeltaY = rightDeltaY

            // Добавим точки и кривые для отображения
            let cp1 = Point(style: .support, isDraggable: false, position: leftControlPoint)
            let cp2 = Point(style: .support, isDraggable: false, position: rightControlPoint)
            let container = QuibicBridgeContainer(mp1: mainPoints[i],
                                                  mp2: mainPoints[i + 1],
                                                  cp1: cp1,
                                                  cp2: cp2)
            controlPoints.append(contentsOf: [cp1, cp2])
            containers.append(container)
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
}
