//
//  DoubleManualQubicBezierSplineFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import Foundation

final class DoubleManualQubicBezierSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = DoubleManualQubicBezierSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Manual bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
