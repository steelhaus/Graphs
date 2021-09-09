//
//  CommonBranchedBezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import SwiftUI

protocol CommonBranchedBezierSplineModel {
    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { get }

    var shouldShowKSelector: Bool { get }

    /// Создать новые точки для графика
    func makePoints() -> [SplineBranch]

    /// Посчитать соединения между точками
    /// - Parameters:
    ///   - branches: Ветки с точками
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    func calculateBridges(branches: [SplineBranch],
                          showControlPoints: Bool) -> BridgesInfo?

    func calculateBridges(branches: [SplineBranch],
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo?
}

extension CommonBranchedBezierSplineModel {
    func calculateBridges(branches: [SplineBranch],
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo? {
        nil
    }

    func calculateBridges(branches: [SplineBranch],
                          showControlPoints: Bool) -> BridgesInfo? {
        nil
    }

    var shouldShowKSelector: Bool { false }
}

enum SplineBranchType {
    case main
    case child(rootIndex: Int)
}

struct SplineBranch {
    let type: SplineBranchType
    var mainPoints: [Point]
}
