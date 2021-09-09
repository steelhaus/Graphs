//
//  QubicBezierSplineSampleViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import Foundation

final class QubicBezierSplineSampleViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = QubicBezierSplineSampleModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Qubic bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
