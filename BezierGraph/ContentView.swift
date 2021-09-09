//
//  ContentView.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 28.07.2021.
//

import SwiftUI

struct ContentView: View {

    @State private var showQuadBezierView: Bool = false
    @State private var showQubicBezierView: Bool = false
    @State private var showManualQubicBezierView: Bool = false
    @State private var showMergedQubicBezierSplineView: Bool = false
    @State private var showLinearBranchedView: Bool = false
    @State private var showMergedQubicBranchedBezierSplineView: Bool = false
    @State private var showMixedBezierSplineView: Bool = false
    @State private var showBezierView: Bool = false
    @State private var showLagrange: Bool = false
    @State private var showQubicSpline: Bool = false
    @State private var showApproximation: Bool = false
    @State private var showBranchedBezierView: Bool = false
    @State private var showCatmullRomView: Bool = false
    @State private var showCatmullRomBezierView: Bool = false
    @State private var showCatmullRomBranchedBezierView: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    Group {
                        NavigationLink(
                            destination: QuadBezierSplineSampleViewFactory.make(),
                            isActive: $showQuadBezierView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: QubicBezierSplineSampleViewFactory.make(),
                            isActive: $showQubicBezierView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: DoubleManualQubicBezierSplineViewFactory.make(),
                            isActive: $showManualQubicBezierView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: MergedQubicSplineSampleViewFactory.make(),
                            isActive: $showMergedQubicBezierSplineView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: LinearBranchedViewFactory.make(),
                            isActive: $showLinearBranchedView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: MergedQubicBranchedSplineViewFactory.make(),
                            isActive: $showMergedQubicBranchedBezierSplineView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: MixedBezierSplineViewFactory.make(),
                            isActive: $showMixedBezierSplineView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: BezierSplineViewFactory.make(),
                            isActive: $showBezierView) {
                            EmptyView()
                        }
                        NavigationLink(
                            destination: LagrangePolynomialViewFactory.make(),
                            isActive: $showLagrange) {
                            EmptyView()
                        }
                    }
                    NavigationLink(
                        destination: QubicSplineViewFactory.make(),
                        isActive: $showQubicSpline) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: ApproximationSplineViewFactory.make(),
                        isActive: $showApproximation) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: BezierBranchedSplineViewFactory.make(),
                        isActive: $showBranchedBezierView) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: CatmullRomSplineViewFactory.make(),
                        isActive: $showCatmullRomView) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: CatmullRomBezierSplineViewFactory.make(),
                        isActive: $showCatmullRomBezierView) {
                        EmptyView()
                    }
                    NavigationLink(
                        destination: CatmullRomBranchedBezierSplineViewFactory.make(),
                        isActive: $showCatmullRomBranchedBezierView) {
                        EmptyView()
                    }
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            GraphButton(title: "1) Quad bezier sample", state: $showQuadBezierView)
                            GraphButton(title: "2) Qubic bezier sample", state: $showQubicBezierView)
                            GraphButton(title: "3) Double quad bezier sample", state: $showManualQubicBezierView)
                            GraphButton(title: "4) Qubic simply merged spline", state: $showMergedQubicBezierSplineView)
                            GraphButton(title: "5) Linear spline (branched)", state: $showLinearBranchedView)
                            GraphButton(title: "6) Qubic simply merged spline (branched)", state: $showMergedQubicBranchedBezierSplineView)
                            GraphButton(title: "7) Qubic+quad mix spline", state: $showMixedBezierSplineView)
                            GraphButton(title: "8) Lagrange", state: $showLagrange)
                            GraphButton(title: "9) Catmull-Rom spline", state: $showCatmullRomView)
                            GraphButton(title: "10) Catmull-Rom bezier spline", state: $showCatmullRomBezierView)
                        }
                        GraphButton(title: "11) Catmull-Rom bezier spline (branched)", state: $showCatmullRomBranchedBezierView)
                        GraphButton(title: "12) C-Spline", state: $showQubicSpline)
                        GraphButton(title: "13) Bezier approximation", state: $showApproximation)
                        GraphButton(title: "14) Bezier spline", state: $showBezierView)
                        GraphButton(title: "15) Bezier spline (branched)", state: $showBranchedBezierView)
                    }
                }
                .padding(.vertical)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 568, height: 320))
    }
}

struct GraphButton: View {
    let title: String
    @Binding var state: Bool

    var body: some View {
        Group {
            Button(action: {
                state = true
            }, label: {
                Text(title)
            })
            .padding(8)
        }
        .padding(.horizontal)
    }
}
