//
//  LagrangePolynomialViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 08.09.2021.
//

import Foundation

final class LagrangePolynomialViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = LagrangePolynomialModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "Lagrange"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
