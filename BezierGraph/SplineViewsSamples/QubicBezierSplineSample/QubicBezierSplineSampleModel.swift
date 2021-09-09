//
//  QubicBezierSplineSampleModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import UIKit

final class QubicBezierSplineSampleModel: CommonBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { true }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> PointsInfo {
        let mainPoints = [
            Point(position: CGPoint(x: 142, y: 292)),
            Point(position: CGPoint(x: 310, y: 350))
        ]
        let controlPoints = [
            Point(style: .support, position: .init(x: 220, y: 187)),
            Point(style: .support, position: .init(x: 350, y: 222))
        ]
        return PointsInfo(mainPoints: mainPoints, controlPoints: controlPoints)
    }

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    /// - Returns: Новые контрольные точки и связи
    func calculateBridges(mainPoints: [Point], controlPoints: [Point], showControlPoints: Bool) -> BridgesInfo {
        // Calculate main bridges info
        var bridgeContainers: [QuibicBridgeContainer] = []
        for index in 0 ..< mainPoints.count - 1 {
            bridgeContainers.append(
                QuibicBridgeContainer(mp1: mainPoints[index],
                                      mp2: mainPoints[index + 1],
                                      cp1: controlPoints[index * 2],
                                      cp2: controlPoints[index * 2 + 1])
            )
        }

        var bridges: [Bridge] = []

        // Main bridges
        for bridge in bridgeContainers {
            bridges.append(Bridge(style: .main,
                                  type: .qubic(firstControlPoint: bridge.cp1.position,
                                               secondControlPoint: bridge.cp2.position),
                                  startPoint: bridge.mp1.position,
                                  endPoint: bridge.mp2.position))
        }

        // Support bridges
        if showControlPoints {
            for bridge in bridgeContainers {
                for pointsPair in [(bridge.mp1, bridge.cp1), (bridge.mp2, bridge.cp2)] {
                    bridges.append(Bridge(style: .support,
                                          type: .linear,
                                          startPoint: pointsPair.0.position,
                                          endPoint: pointsPair.1.position))
                }
            }
        }

        return BridgesInfo(controlPoints: controlPoints, bridges: bridges)
    }
}
