//
//  MixedBezierSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 07.09.2021.
//

import Foundation

final class MixedBezierSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = MixedBezierSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Mixed bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
