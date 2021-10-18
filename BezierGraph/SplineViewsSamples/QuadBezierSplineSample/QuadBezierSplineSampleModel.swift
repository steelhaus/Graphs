//
//  QuadBezierSplineSampleModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import UIKit

final class QuadBezierSplineSampleModel: CommonBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { true }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 150, y: 140)),
            Point(position: CGPoint(x: 200, y: 280))
        ]
        let controlPoints = [
            Point(style: .support, position: .init(x: 314, y: 150))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: controlPoints)
    }

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    /// - Returns: Новые контрольные точки и связи
    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool, k: CGFloat) -> BridgesInfo {
        // Calculate main bridges info
        var bridgeContainers: [QuadBridgeContainer] = []
        for index in 0 ..< mainPoints.count - 1 {
            bridgeContainers.append(
                QuadBridgeContainer(mp1: mainPoints[index],
                                    mp2: mainPoints[index + 1],
                                    cp: controlPoints[index])
            )
        }

        var bridges: [Bridge] = []

        // Main bridges
        for bridge in bridgeContainers {
            bridges.append(Bridge(style: .main,
                                  type: .quadratic(controlPoint: bridge.cp.position),
                                  startPoint: bridge.mp1.position,
                                  endPoint: bridge.mp2.position))
        }

        // Support bridges
        if showControlPoints {
            for bridge in bridgeContainers {
                for mainPoint in [bridge.mp1, bridge.mp2] {
                    bridges.append(Bridge(style: .support,
                                          type: .linear,
                                          startPoint: mainPoint.position,
                                          endPoint: bridge.cp.position))
                }
            }
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }
}
