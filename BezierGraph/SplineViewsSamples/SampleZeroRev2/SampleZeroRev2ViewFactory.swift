//
//  SampleZeroRev2ViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 17.10.2021.
//

import Foundation

final class SampleZeroRev2ViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = SampleZeroRev2Model()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Sample Zero, Rev: 2"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
