//
//  BezierSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import Foundation

final class BezierSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = BezierSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Bezier spline"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
