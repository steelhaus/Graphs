//
//  CommonBezierSplineViewModel.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import SwiftUI

/// Вью-модель для графика
final class CommonBezierSplineViewModel: ObservableObject {

    /// Отображать ли контрольные точки
    @Published var showControlPoints: Bool = false {
        didSet { calculateBridges() }
    }

    var showKSelector: Bool {
        model.shouldShowKSelector
    }

    /// Размер точек
    @Published var pointsScale: CGFloat = 1.0

    /// Коэффициент, принимающий значения от 0 до 1
    @Published var k: CGFloat = 0.15 {
        didSet { calculateBridges() }
    }

    /// Связи для отображения
    @Published private(set) var displayBridges: [Bridge] = []

    @Published private(set) var displayPaths: [PathInfo] = []

    /// Все точки для отображения
    var displayPoints: [Point] {
        if showControlPoints {
            return mainPoints + controlPoints
        } else {
            return mainPoints
        }
    }

    /// Модель графика
    private let model: CommonBezierSplineModel

    /// Основные точки
    private var mainPoints: [Point] {
        didSet { calculateBridges() }
    }

    /// Контрольные точки
    private var controlPoints: [Point] {
        didSet { if model.manualControlPointsEnabled { calculateBridges() } }
    }

    init(model: CommonBezierSplineModel) {
        self.model = model

        let points = model.makePoints()
        mainPoints = points.mainPoints
        controlPoints = points.controlPoints

        calculateBridges()
    }


    /// Установить новое положение для точки
    /// - Parameters:
    ///   - location: Новое положение точки
    ///   - pointId: Идентификатор точки
    func setLocation(_ location: CGPoint, toPointId pointId: UUID) {
        print(location)
        if let index = mainPoints.firstIndex(where: { $0.id == pointId }) {
            mainPoints[index].position = location
        } else if let index = controlPoints.firstIndex(where: { $0.id == pointId }) {
            controlPoints[index].position = location
        }
    }

    private func calculateBridges() {
        let result = model.calculateBridges(mainPoints: mainPoints,
                                            controlPoints: controlPoints,
                                            showControlPoints: showControlPoints, k: k)
        displayBridges = result.bridges
        if !model.manualControlPointsEnabled {
            controlPoints = result.controlPoints
        }

        displayPaths = model.calculatePaths(points: mainPoints)
    }
}
