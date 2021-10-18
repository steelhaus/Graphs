//
//  MergedQuadSplineSampleModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import UIKit

final class MergedQubicSplineSampleModel: CommonBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 48, y: 116)),
            Point(position: CGPoint(x: 132, y: 201)),
            Point(position: CGPoint(x: 214, y: 276)),
            Point(position: CGPoint(x: 273, y: 185)),
            Point(position: CGPoint(x: 356, y: 249)),
            Point(position: CGPoint(x: 405, y: 125)),
            Point(position: CGPoint(x: 494, y: 42)),
            Point(position: CGPoint(x: 586, y: 114))
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
        // Calculate main bridges info
        var controlPoints: [Point] = []
        var bridgeContainers: [QuibicBridgeContainer] = []
        for index in 0 ..< mainPoints.count - 1 {
            let startPoint = mainPoints[index]
            let endPoint = mainPoints[index + 1]
            let centerX = (startPoint.position.x + endPoint.position.x) / 2
            let cp1Position = CGPoint(x: centerX, y: startPoint.position.y)
            let cp2Position = CGPoint(x: centerX, y: endPoint.position.y)
            let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
            let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
            controlPoints.append(contentsOf: [cp1, cp2])
            bridgeContainers.append(QuibicBridgeContainer(mp1: startPoint, mp2: endPoint, cp1: cp1, cp2: cp2))
        }

        // Main bridges
        var bridges: [Bridge] = bridgeContainers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = bridgeContainers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }
}
