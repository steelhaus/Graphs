//
//  MergedQubicBranchedSplineModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 07.09.2021.
//

import UIKit

final class MergedQubicBranchedSplineModel: CommonBranchedBezierSplineModel {

    /// Возможно ли самостоятельно изменять контрольные точки
    var manualControlPointsEnabled: Bool { false }

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
                          showControlPoints: Bool) -> BridgesInfo? {
        guard let mainBranch = branches.first(
                where: { if case .main = $0.type { return true } else { return false } }
        ) else { return nil }
        let secondaryBranches = branches.filter { if case .child = $0.type { return true } else { return false } }

        var controlPoints: [Point] = []
        var bridgeContainers: [QuibicBridgeContainer] = []

        for index in 0 ..< mainBranch.mainPoints.count - 1 {
            let startPoint = mainBranch.mainPoints[index]
            let endPoint = mainBranch.mainPoints[index + 1]
            let meta = calculateBridgeBetween(startPoint: startPoint, and: endPoint)
            controlPoints.append(contentsOf: meta.controlPoints)
            bridgeContainers.append(meta.bridgeContainer)
        }

        for secondaryBranch in secondaryBranches {
            guard case .child(let rootIndex) = secondaryBranch.type else { continue }
            for index in 0 ..< secondaryBranch.mainPoints.count {
                let endPoint = secondaryBranch.mainPoints[index]
                let startPoint = index == 0 ? mainBranch.mainPoints[rootIndex] : secondaryBranch.mainPoints[index - 1]
                let meta = calculateBridgeBetween(startPoint: startPoint, and: endPoint)
                controlPoints.append(contentsOf: meta.controlPoints)
                bridgeContainers.append(meta.bridgeContainer)
            }
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

    private func calculateBridgeBetween(startPoint: Point, and endPoint: Point) -> (controlPoints: [Point], bridgeContainer: QuibicBridgeContainer) {
        let centerX = (startPoint.position.x + endPoint.position.x) / 2
        let cp1Position = CGPoint(x: centerX, y: startPoint.position.y)
        let cp2Position = CGPoint(x: centerX, y: endPoint.position.y)
        let cp1 = Point(style: .support, isDraggable: false, position: cp1Position)
        let cp2 = Point(style: .support, isDraggable: false, position: cp2Position)
        let bridgeContainer = QuibicBridgeContainer(mp1: startPoint, mp2: endPoint, cp1: cp1, cp2: cp2)
        return ([cp1, cp2], bridgeContainer)
    }
}
