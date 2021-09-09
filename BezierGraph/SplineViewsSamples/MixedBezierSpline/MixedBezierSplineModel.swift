//
//  MixedBezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 07.09.2021.
//

import Foundation
import UIKit

final class MixedBezierSplineModel: CommonBezierSplineModel {

    /// Выпуклость
    private enum Convex {
        /// вверх
        case up
        /// вниз
        case down

        mutating func toggle() {
            switch self {
                case .down: self = .up
                case .up: self = .down
            }
        }
    }

    /// Локальный минимум/максимум
    private enum Extremum {
        /// максимум
        case min
        /// минимум
        case max
    }

    // Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 42, y: 115)),
            Point(position: CGPoint(x: 131, y: 184)),
            Point(position: CGPoint(x: 220, y: 310)),
            Point(position: CGPoint(x: 299, y: 217)),
            Point(position: CGPoint(x: 351, y: 100)),
            Point(position: CGPoint(x: 473, y: 270)),
            Point(position: CGPoint(x: 559, y: 52)),
            Point(position: CGPoint(x: 678, y: 159))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    /// - Returns: Новые контрольные точки и связи
    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool) -> BridgesInfo {
        guard mainPoints.count >= 2 else { return .init(controlPoints: [], bridges: []) }

        // Calculate main bridges info
        var controlPoints: [Point] = []
        var qubicBridgeContainers: [QuibicBridgeContainer] = []
        var quadBridgeContainers: [QuadBridgeContainer] = []

        var convex: Convex = mainPoints[0].position.y > mainPoints[1].position.y ? .down : .up

        for index in 0 ..< mainPoints.count - 1 {
            let startPoint = mainPoints[index]
            let destPoint = mainPoints[index + 1]
            let nextPoint = mainPoints.count > (index + 2) ? mainPoints[index + 2] : nil
            let extremum: Extremum?
            if mainPoints.count == index + 2 {
                // Отдельная задаем для последней точки обязательный экстремум
                extremum = mainPoints[index].position.y < mainPoints[index + 1].position.y ? .min : .max
            } else {
                extremum = getExtremumOf(destPoint, neighbourPoint1: startPoint, neighbourPoint2: nextPoint)
            }

            switch extremum {
                case .min:
                    switch convex {
                        case .down:
                            makeQuadSpline(startPoint: startPoint,
                                           destPoint: destPoint,
                                           convex: convex,
                                           controlPointsEnabled: showControlPoints,
                                           containers: &quadBridgeContainers,
                                           controlPoints: &controlPoints)
                        case .up:
                            makeQubicSpline(startPoint: startPoint,
                                            destPoint: destPoint,
                                            startConvex: convex,
                                            controlPointsEnabled: showControlPoints,
                                            containers: &qubicBridgeContainers,
                                            controlPoints: &controlPoints)
                    }
                    convex = .down
                case .max:
                    switch convex {
                        case .down:
                            makeQubicSpline(startPoint: startPoint,
                                            destPoint: destPoint,
                                            startConvex: convex,
                                            controlPointsEnabled: showControlPoints,
                                            containers: &qubicBridgeContainers,
                                            controlPoints: &controlPoints)
                        case .up:
                            makeQuadSpline(startPoint: startPoint,
                                           destPoint: destPoint,
                                           convex: convex,
                                           controlPointsEnabled: showControlPoints,
                                           containers: &quadBridgeContainers,
                                           controlPoints: &controlPoints)
                    }
                    convex = .up
                case .none:
                    makeQuadSpline(startPoint: startPoint,
                                   destPoint: destPoint,
                                   convex: convex,
                                   controlPointsEnabled: showControlPoints,
                                   containers: &quadBridgeContainers,
                                   controlPoints: &controlPoints)
                    convex.toggle()
            }
        }

        // Main bridges
        var bridges = qubicBridgeContainers.map { $0.makeBridge(style: .main) } +
            quadBridgeContainers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = qubicBridgeContainers.flatMap { $0.makeSupportBridges(style: .support) }
                + quadBridgeContainers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }

    private func getExtremumOf(_ point: Point, neighbourPoint1: Point?, neighbourPoint2: Point?) -> Extremum? {
        guard let np1 = neighbourPoint1, let np2 = neighbourPoint2 else { return nil }
        let position = point.position.y
        let n1Position = np1.position.y
        let n2Position = np2.position.y
        if position < n1Position && position < n2Position {
            return .max
        }
        if position > n1Position && position > n2Position {
            return .min
        }
        return nil
    }

    private func makeQuadSpline(startPoint: Point,
                                destPoint: Point,
                                convex: Convex,
                                controlPointsEnabled: Bool,
                                containers: inout [QuadBridgeContainer],
                                controlPoints: inout [Point]) {
        let controlPoint: Point
        let delta: CGFloat = 0.0 // Для показательных целей
        switch convex {
            case .up:
                // Берем x, соответствующий точке с наименьшим y
                var x = startPoint.position.y < destPoint.position.y ? destPoint.position.x : startPoint.position.x
                if startPoint.position.y < destPoint.position.y {
                    x = x - abs(startPoint.position.x - destPoint.position.x) * delta
                } else {
                    x = x + abs(startPoint.position.x - destPoint.position.x) * delta
                }
                // Берем y, соответствующий точке на наибольшим y
                var y = min(startPoint.position.y, destPoint.position.y)
                y = y + abs(startPoint.position.y - destPoint.position.y) * delta
                controlPoint = Point(style: .support, isDraggable: false, position: CGPoint(x: x, y: y))
            case .down:
                // Берем x, соответствующий точке с наибольшим y
                var x = startPoint.position.y < destPoint.position.y ? startPoint.position.x : destPoint.position.x
                if startPoint.position.y < destPoint.position.y {
                    x = x + abs(startPoint.position.x - destPoint.position.x) * delta
                } else {
                    x = x - abs(startPoint.position.x - destPoint.position.x) * delta
                }
                // Берем y, соответствующий точке на наименьшим y
                var y = max(startPoint.position.y, destPoint.position.y)
                y = y - abs(startPoint.position.y - destPoint.position.y) * delta
                controlPoint = Point(style: .support, isDraggable: false, position: CGPoint(x: x, y: y))
        }
        if controlPointsEnabled {
            controlPoints.append(controlPoint)
        }
        let bridge = QuadBridgeContainer(mp1: startPoint, mp2: destPoint, cp: controlPoint)
        containers.append(bridge)
    }

    private func makeQubicSpline(startPoint: Point,
                                 destPoint: Point,
                                 startConvex: Convex,
                                 controlPointsEnabled: Bool,
                                 containers: inout [QuibicBridgeContainer],
                                 controlPoints: inout [Point]) {

        let centerX = (startPoint.position.x + destPoint.position.x) / 2
        let cp1Position = CGPoint(x: centerX, y: startPoint.position.y)
        let cp2Position = CGPoint(x: centerX, y: destPoint.position.y)
        let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
        let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
        if controlPointsEnabled {
            controlPoints.append(contentsOf: [cp1, cp2])
        }
        let bridge = QuibicBridgeContainer(mp1: startPoint, mp2: destPoint, cp1: cp1, cp2: cp2)
        containers.append(bridge)
    }

}
