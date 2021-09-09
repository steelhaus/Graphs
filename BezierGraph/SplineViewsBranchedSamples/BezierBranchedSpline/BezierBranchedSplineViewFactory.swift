//
//  BezierBranchedSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import Foundation

final class BezierBranchedSplineViewFactory {
    static func make() -> CommonBranchedBezierSplineView {
        let model = BezierBranchedSplineModel()
        let viewModel = CommonBranchedBezierSplineViewModel(model: model)
        let title = "Bezier"
        return CommonBranchedBezierSplineView(title: title, viewModel: viewModel)
    }
}
