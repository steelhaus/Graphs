//
//  CatmullRomBranchedBezierSplineViewFactory.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 09.09.2021.
//

import Foundation

final class CatmullRomBranchedBezierSplineViewFactory {
    static func make() -> CommonBranchedBezierSplineView {
        let model = CatmullRomBranchedBezierSplineModel()
        let viewModel = CommonBranchedBezierSplineViewModel(model: model)
        let title = "Catmull-Rom"
        return CommonBranchedBezierSplineView(title: title, viewModel: viewModel)
    }
}
