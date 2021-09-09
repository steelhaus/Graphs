//
//  MergedQuadSplineSampleViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import Foundation

final class MergedQubicSplineSampleViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = MergedQubicSplineSampleModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Merged qubic bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
