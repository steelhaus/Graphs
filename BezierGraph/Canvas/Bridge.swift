//
//  Bridge.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

struct Bridge: Identifiable {
    // UI
    let color: Color
    let lineWidth: CGFloat

    // General
    let id = UUID()
    let type: BridgeType

    // Geometry
    let startPoint: CGPoint
    let endPoint: CGPoint

    init(style: BridgeStyle = .main,
         type: BridgeType,
         startPoint: CGPoint,
         endPoint: CGPoint) {

        self.color = style.color
        self.lineWidth = style.lineWidth
        self.type = type
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

struct PathInfo: Identifiable {
    // UI
    let color: Color
    let lineWidth: CGFloat

    // General
    let id = UUID()

    // Geometry
    let path: Path

    init(style: BridgeStyle = .main,
         path: Path) {
        self.color = style.color
        self.lineWidth = style.lineWidth
        self.path = path
    }
}
