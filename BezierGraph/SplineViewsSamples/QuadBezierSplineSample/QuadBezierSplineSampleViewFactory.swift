//
//  QuadBezierSplineSampleViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import Foundation

final class QuadBezierSplineSampleViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = QuadBezierSplineSampleModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Quadratic bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
