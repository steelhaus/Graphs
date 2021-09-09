//
//  LinearBranchedViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import Foundation

final class LinearBranchedViewFactory {
    static func make() -> CommonBranchedBezierSplineView {
        let model = LinearBranchedGraphModel()
        let viewModel = CommonBranchedBezierSplineViewModel(model: model)
        let title = "Linear"
        return CommonBranchedBezierSplineView(title: title, viewModel: viewModel)
    }
}
