//
//  PointStyle.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

enum PointStyle {
    case main(color: Color)
    case standard
    case support

    var color: Color {
        switch self {
            case let .main(color):
                return color
            case .standard:
                return .red
            case .support:
                return .gray
        }
    }

    var size: CGFloat {
        switch self {
            case .main, .standard:
                return 20.0
            case .support:
                return 10.0
        }
    }
}
