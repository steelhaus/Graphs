//
//  ApprozimationSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import Foundation

final class ApproximationSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = ApproximationSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "approx"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
