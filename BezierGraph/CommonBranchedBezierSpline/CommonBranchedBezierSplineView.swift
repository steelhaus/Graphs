//
//  CommonBranchedBezierSplineView.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 31.08.2021.
//

import SwiftUI

/// Вью для отображения графика с ветвями
struct CommonBranchedBezierSplineView: View {
    let title: String
    @StateObject var viewModel: CommonBranchedBezierSplineViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Canvas(points: viewModel.displayPoints,
                   bridges: viewModel.displayBridges,
                   pointsScale: viewModel.pointsScale,
                   onPointDrag: { point, location in
                    viewModel.setLocation(location, toPointId: point.id)
                   })
                .padding()
            Toggle(isOn: $viewModel.showControlPoints) {
                Text("Show control points:")
                    .font(.title2)
            }
            .padding(.horizontal)
            HStack(spacing: 40) {
                Text("Points size: ")
                    .font(.title2)
                Slider(value: $viewModel.pointsScale, in: 0...1)
                    .frame(width: 200)
            }
            .padding(.bottom)
            .padding(.horizontal)
            if viewModel.showKSelector {
                HStack(spacing: 40) {
                    Text("Curve coefficient: ")
                        .font(.title2)
                    Slider(value: $viewModel.k, in: 0...1)
                        .frame(width: 200)
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
        }
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct CommonBranchedBezierSplineView_Previews: PreviewProvider {
    static var previews: some View {
        LinearBranchedViewFactory.make()
    }
}
