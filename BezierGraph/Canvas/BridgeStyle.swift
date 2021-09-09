//
//  BridgeStyle.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

enum BridgeStyle {
    case main
    case support
    case custom(color: Color, lineWidth: CGFloat)

    var color: Color {
        switch self {
            case .main:
                return .blue
            case .support:
                return .gray
            case .custom(let color, _):
                return color
        }
    }

    var lineWidth: CGFloat {
        switch self {
            case .main:
                return 2.0
            case .support:
                return 0.5
            case .custom(_, let lineWidth):
                return lineWidth
        }
    }
}
