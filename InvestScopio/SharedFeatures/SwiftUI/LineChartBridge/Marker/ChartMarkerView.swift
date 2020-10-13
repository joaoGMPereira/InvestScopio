//
//  ChartMarker View.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 01/10/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Charts

enum ShadeBackgroundStyle {
    case left
    case right
    case both
}

class ChartMarkerView: IMarker {
    var offset: CGPoint

    let color: UIColor
    let chartView: ChartViewBase
    let shadeStyle: ShadeBackgroundStyle
    let hightlightLineWidth: CGFloat

    init(color: UIColor = .JEWDefault(), chartView: ChartViewBase, shadeStyle: ShadeBackgroundStyle = .left, highlightWidth: CGFloat = 2) {
        self.color = color
        self.chartView = chartView
        self.offset = .zero
        self.shadeStyle = shadeStyle
        self.hightlightLineWidth = highlightWidth
    }

    func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
    }

    func offsetForDrawing(atPoint: CGPoint) -> CGPoint {
        return self.offset
    }

    func draw(context: CGContext, point: CGPoint) {
        let offset = self.offsetForDrawing(atPoint: point)

        let layer = CALayer()
        layer.frame = CGRect(origin: .zero, size: self.chartView.frame.size)
        layer.backgroundColor = self.color.cgColor
        layer.opacity = 0.6

        context.saveGState()
        UIGraphicsPushContext(context)

        switch self.shadeStyle {
        case .right:
            context.translateBy(x: (point.x - offset.x) - layer.frame.width, y: 0 + offset.y)
            layer.render(in: context)
        case .both:
            //Cria path onde será destacado
            let path = UIBezierPath(rect: layer.frame)

            //Cria a area onde sera transparente
            let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: point.x - (offset.x / 2), y: 0),
                                                     size: CGSize(width: self.hightlightLineWidth + offset.x, height: self.chartView.frame.height)))

            path.append(rectPath)
            path.usesEvenOddFillRule = true

            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.fillRule = CAShapeLayerFillRule.evenOdd

            layer.mask = fillLayer
            layer.render(in: context)
        default:
            context.translateBy(x: point.x + offset.x, y: 0 + offset.y)
            layer.render(in: context)
        }

        UIGraphicsPopContext()
        context.restoreGState()
    }
}
