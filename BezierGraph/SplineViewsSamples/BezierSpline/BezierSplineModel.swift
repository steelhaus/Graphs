//
//  BezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import UIKit

final class BezierSplineModel: CommonBezierSplineModel {
    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 45, y: 111)),
            Point(position: CGPoint(x: 135, y: 281)),
            Point(position: CGPoint(x: 202, y: 154)),
            Point(position: CGPoint(x: 296, y: 167)),
            Point(position: CGPoint(x: 365, y: 294)),
            Point(position: CGPoint(x: 449, y: 50)),
            Point(position: CGPoint(x: 494, y: 394)),
            Point(position: CGPoint(x: 620, y: 257))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: [])
    }

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    /// - Returns: Новые контрольные точки и связи
    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool, k: CGFloat) -> BridgesInfo {
        let configuration = BezierSplineConfiguration()
        let cgPoints = mainPoints.map(\.position)
        let controlPoints = configuration.configureControlPoints(data: cgPoints)

        var bridgeContainers: [QuibicBridgeContainer] = []
        var cps: [Point] = []

        for index in 0 ..< mainPoints.count - 1 {
            let startPoint = mainPoints[index]
            let endPoint = mainPoints[index + 1]
            let cp1Position = controlPoints[index].firstControlPoint
            let cp2Position = controlPoints[index].secondControlPoint
            let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
            let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
            let container = QuibicBridgeContainer(mp1: startPoint, mp2: endPoint, cp1: cp1, cp2: cp2)
            bridgeContainers.append(container)
            if showControlPoints {
                cps.append(contentsOf: [cp1, cp2])
            }
        }

        // Main bridges
        var bridges: [Bridge] = bridgeContainers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = bridgeContainers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return BridgesInfo(controlPoints: cps, bridges: bridges)
    }
}
