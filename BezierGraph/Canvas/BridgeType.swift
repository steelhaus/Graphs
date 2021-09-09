//
//  BridgeType.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

enum BridgeType {
    case linear
    case quadratic(controlPoint: CGPoint)
    case qubic(firstControlPoint: CGPoint, secondControlPoint: CGPoint)
}
