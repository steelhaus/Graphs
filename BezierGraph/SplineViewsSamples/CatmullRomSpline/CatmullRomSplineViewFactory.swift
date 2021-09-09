//
//  CatmullRomSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import Foundation

final class CatmullRomSplineViewFactory {
    static func make() -> CommonBezierSplineView {
        let model = CatmullRomSplineModel()
        let viewModel = CommonBezierSplineViewModel(model: model)
        let title = "CatmullRom"
        return CommonBezierSplineView(title: title, viewModel: viewModel)
    }
}
