//
//  CommonBezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import SwiftUI

/// Информация о связях между точками
struct BridgesInfo {
    /// Рассчитанные контрольные точки
    let controlPoints: [Point]
    /// Рассчитанные связи
    let bridges: [Bridge]
}

/// Набор стартовых точек
struct PointsInfo {
    /// Основные точки
    let mainPoints: [Point]
    /// Контрольные точки
    let controlPoints: [Point]
}

/// Общая модель для графиков
protocol CommonBezierSplineModel {
    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { get }

    var shouldShowKSelector: Bool { get }

    /// Создать новые точки для графика
    func makePoints() -> PointsInfo

    /// Подсчитать соединения между точками
    /// - Parameters:
    ///   - mainPoints: Основные точки
    ///   - controlPoints: Контрольные точки
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    func calculateBridges(mainPoints: [Point],
                          controlPoints: [Point],
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo

    func calculatePaths(points: [Point]) -> [PathInfo]
}

extension CommonBezierSplineModel {
    func calculateBridges(mainPoints: [Point],
                          controlPoints: [Point],
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo {
        .init(controlPoints: [], bridges: [])
    }

    func calculatePaths(points: [Point]) -> [PathInfo] {
        []
    }

    var shouldShowKSelector: Bool { false }
}

// MARK: - Helpers

/// Вспомогательная структура для построения связей
struct QuibicBridgeContainer {
    /// Первая основная точка
    let mp1: Point
    /// Вторая основная точка
    let mp2: Point
    /// Первая контрольная точка
    let cp1: Point
    /// Вторая контрольная точка
    let cp2: Point

    func makeBridge(style: BridgeStyle) -> Bridge {
        Bridge(style: style,
               type: .qubic(firstControlPoint: cp1.position, secondControlPoint: cp2.position),
               startPoint: mp1.position,
               endPoint: mp2.position)
    }

    func makeSupportBridges(style: BridgeStyle) -> [Bridge] {
        let pairs = [(mp1, cp1), (mp2, cp2)]
        return pairs.map {
            Bridge(style: style, type: .linear, startPoint: $0.0.position, endPoint: $0.1.position)
        }
    }
}

/// Вспомогательная структура для построения связей
struct QuadBridgeContainer {
    /// Первая основная точка
    let mp1: Point
    /// Вторая основная точка
    let mp2: Point
    /// Контрольная точка
    let cp: Point

    func makeBridge(style: BridgeStyle) -> Bridge {
        Bridge(style: style,
               type: .quadratic(controlPoint: cp.position),
               startPoint: mp1.position,
               endPoint: mp2.position)
    }

    func makeSupportBridges(style: BridgeStyle) -> [Bridge] {
        let points = [mp1, mp2]
        return points.map {
            Bridge(style: style, type: .linear, startPoint: $0.position, endPoint: cp.position)
        }

    }
}
