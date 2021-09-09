//
//  Point.swift
//  BezierGraph
//
//  Created by Точилин Анатолий Витальевич on 13.08.2021.
//

import SwiftUI

struct Point: Identifiable {
    // UI
    let color: Color
    let size: CGFloat
    let isDraggable: Bool
    private let style: PointStyle

    // General
    let id = UUID()

    // Geometry
    var position: CGPoint

    init(style: PointStyle = .standard,
         isDraggable: Bool = true,
         position: CGPoint) {
        self.style = style
        self.color = style.color
        self.size = style.size
        self.isDraggable = isDraggable
        self.position = position
    }

    func sizeWithScale(_ scale: CGFloat) -> CGFloat {
        if case .support = style {
            return size
        }
        return size * scale
    }
}
