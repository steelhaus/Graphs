//
//  CatmullRomBezierSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import Foundation

final class CatmullRomBezierSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = CatmullRomBezierSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "CatmullRom Bezier"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
