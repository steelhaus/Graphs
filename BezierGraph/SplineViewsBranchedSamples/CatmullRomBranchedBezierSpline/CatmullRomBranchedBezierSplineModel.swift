//
//  CatmullRomBranchedBezierSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import UIKit

final class CatmullRomBranchedBezierSplineModel: CommonBranchedBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

    var shouldShowKSelector: Bool { true }

    /// Создать новые точки для графика
    /// - Returns: Точки для графика
    func makePoints() -> [SplineBranch] {
        let mainBranchPoints = [
            Point(position: CGPoint(x: 61, y: 126)),
            Point(position: CGPoint(x: 212, y: 210)),
            Point(position: CGPoint(x: 387, y: 254)),
            Point(position: CGPoint(x: 577, y: 206))
        ]
        let mainBranch = SplineBranch(type: .main, mainPoints: mainBranchPoints)

        let extraBranchPoints1 = [
            Point(style: .main(color: .green), position: CGPoint(x: 382, y: 123)),
            Point(style: .main(color: .green), position: CGPoint(x: 577, y: 89))
        ]
        let extraBranch1 = SplineBranch(type: .child(rootIndex: 1), mainPoints: extraBranchPoints1)

        let extraBranchPoints2 = [
            Point(style: .main(color: .orange), position: CGPoint(x: 539, y: 341)),
            Point(style: .main(color: .orange), position: CGPoint(x: 631, y: 454))
        ]
        let extraBranch2 = SplineBranch(type: .child(rootIndex: 2), mainPoints: extraBranchPoints2)

        let extraBranchPoints3 = [
            Point(style: .main(color: .purple), position: CGPoint(x: 167, y: 263)),
            Point(style: .main(color: .purple), position: CGPoint(x: 372, y: 385))
        ]
        let extraBranch3 = SplineBranch(type: .child(rootIndex: 0), mainPoints: extraBranchPoints3)

        return [mainBranch, extraBranch1, extraBranch2, extraBranch3]
    }

    /// Посчитать соединения между точками
    /// - Parameters:
    ///   - branches: Ветки с точками
    ///   - showControlPoints: Добавлять ли связи между основными и контрольными точками
    /// - Returns: Новые контрольные точки и связи
    func calculateBridges(branches: [SplineBranch],
                          showControlPoints: Bool,
                          k: CGFloat) -> BridgesInfo? {
        guard let mainBranch = branches.first(
                where: { if case .main = $0.type { return true } else { return false } }
        ) else { return nil }
        let secondaryBranches = branches.filter { if case .child = $0.type { return true } else { return false } }

        var infos: [(bridges: [Bridge], controlPoints: [Point])] = []
        infos.append(calculateInfoFor(mainPoints: mainBranch.mainPoints, showControlPoints: showControlPoints, k: k))

        for branch in secondaryBranches {
            guard case .child(let rootIndex) = branch.type else { continue }
            let startPoint = mainBranch.mainPoints[rootIndex]
            let allPoints = [startPoint] + branch.mainPoints
            infos.append(calculateInfoFor(mainPoints: allPoints, showControlPoints: showControlPoints, k: k))
        }

        let bridges = infos.reduce(into: []) { result, tuple in
            result.append(contentsOf: tuple.bridges)
        }
        let controlPoints = infos.reduce(into: []) { result, tuple in
            result.append(contentsOf: tuple.controlPoints)
        }

        return .init(controlPoints: controlPoints, bridges: bridges)
    }

    private func calculateInfoFor(mainPoints: [Point], showControlPoints: Bool, k: CGFloat) -> (bridges: [Bridge], controlPoints: [Point]) {

        let mainPoints = mainPoints + [mainPoints[mainPoints.count - 1]]
        var containers: [QuibicBridgeContainer] = []
        var controlPoints: [Point] = []
        let points = mainPoints.map(\.position)

        var dl: CGFloat = 0
//        let k: CGFloat = 0.6
        for i in 0 ..< points.count - 2 {
            let dr = (points[i + 2].y - points[i].y) / 2 * k
            let cp1Position = CGPoint(x: points[i].x + k * 30, y: points[i].y + dl)
            let cp2Position = CGPoint(x: points[i + 1].x - k * 30, y: points[i + 1].y - dr)
            let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
            let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
            let container = QuibicBridgeContainer(mp1: mainPoints[i],
                                                  mp2: mainPoints[i + 1],
                                                  cp1: cp1,
                                                  cp2: cp2)
            controlPoints.append(contentsOf: [cp1, cp2])
            containers.append(container)
            dl = dr
        }

        // Main bridges
        var bridges = containers.map { $0.makeBridge(style: .main) }

        // Support bridges
        if showControlPoints {
            let supportBridges = containers.flatMap { $0.makeSupportBridges(style: .support) }
            bridges.append(contentsOf: supportBridges)
        }

        return (bridges, controlPoints)
    }
}
