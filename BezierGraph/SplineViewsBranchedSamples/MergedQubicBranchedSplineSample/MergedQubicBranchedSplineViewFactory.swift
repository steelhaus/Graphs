//
//  MergedQubicBranchedSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 07.09.2021.
//

import Foundation

final class MergedQubicBranchedSplineViewFactory {
    static func make() -> CommonBranchedBezierSplineView {
        let model = MergedQubicBranchedSplineModel()
        let viewModel = CommonBranchedBezierSplineViewModel(model: model)
        let title = "Merged"
        return CommonBranchedBezierSplineView(title: title, viewModel: viewModel)
    }
}
