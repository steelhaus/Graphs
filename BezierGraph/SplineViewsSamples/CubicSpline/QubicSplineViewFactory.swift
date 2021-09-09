//
//  QubicSpineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import Foundation

final class QubicSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = QubicSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "c-spline"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
