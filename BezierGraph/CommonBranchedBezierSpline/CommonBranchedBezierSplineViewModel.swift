//
//  CommonBranchedBezierSplineViewModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import SwiftUI

/// Вью-модель для графика с ветвями
final class CommonBranchedBezierSplineViewModel: ObservableObject {

    /// Отображать ли контрольные точки
    @Published var showControlPoints: Bool = false {
        didSet { calculateBridges() }
    }

    var showKSelector: Bool {
        model.shouldShowKSelector
    }

    /// Размер точек
    @Published var pointsScale: CGFloat = 1.0

    /// Коэффициент для Катмулл-Ром
    @Published var k: CGFloat = 0.8 {
        didSet { calculateBridges() }
    }

    /// Связи для отображения
    @Published private(set) var displayBridges: [Bridge] = []

    /// Все точки для отображения
    var displayPoints: [Point] {
        let mainPoints = branches.flatMap { $0.mainPoints }
        if showControlPoints {
            return mainPoints + controlPoints
        } else {
            return mainPoints
        }
    }

    /// Модель графика
    private let model: CommonBranchedBezierSplineModel

    /// Основные точки
    private var branches: [SplineBranch] {
        didSet { calculateBridges() }
    }

    /// Контрольные точки
    private var controlPoints: [Point] = [] {
        didSet { if model.manualControlPointsEnabled { calculateBridges() } }
    }

    init(model: CommonBranchedBezierSplineModel) {
        self.model = model

        branches = model.makePoints()

        calculateBridges()
    }

    /// Установить новое положение для точки
    /// - Parameters:
    ///   - location: Новое положение точки
    ///   - pointId: Идентификатор точки
    func setLocation(_ location: CGPoint, toPointId pointId: UUID) {
        print(location)
        for (branchIndex, branch) in branches.enumerated() {
            for (pointIndex, point) in branch.mainPoints.enumerated() {
                if point.id == pointId {
                    branches[branchIndex].mainPoints[pointIndex].position = location
                    return
                }
            }
        }
    }

    private func calculateBridges() {
        guard let result = model.calculateBridges(branches: branches, showControlPoints: showControlPoints) ??
                model.calculateBridges(branches: branches, showControlPoints: showControlPoints, k: k)
        else { return }
        displayBridges = result.bridges
        if !model.manualControlPointsEnabled {
            controlPoints = result.controlPoints
        }
    }
}
