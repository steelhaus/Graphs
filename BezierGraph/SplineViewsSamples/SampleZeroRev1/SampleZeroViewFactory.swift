//
//  SampleZeroViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 14.10.2021.
//

import Foundation

final class SampleZeroViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = SampleZeroModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Sample Zero"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
