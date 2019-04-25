//
//  ChartMarker.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 7/4/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import Foundation
import UIKit
import Charts

public class ChartMarker: MarkerImage {
    public var color: UIColor
    public var font: UIFont
    public var textColor: UIColor
    public var minimumSize = CGSize()

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedStringKey : AnyObject]()

    public init(color: UIColor, font: UIFont, textColor: UIColor) {
        self.color = color
        self.font = font
        self.textColor = textColor

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }

    public override func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x,
                y: 40),
            size: size)

        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()

        context.setFillColor(color.cgColor)
        // Draw line
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 + 1.0,
            y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 + 1.0,
            y: rect.origin.y + rect.size.height))

        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 + 1.0,
            y: rect.origin.y + point.y))

        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 - 1.0,
            y: rect.origin.y + point.y))

        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 - 1.0,
            y: rect.origin.y + rect.size.height))

        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width/2.0 + 1.0,
            y: rect.origin.y + rect.size.height))

        // Draw rounded rectango
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        context.addPath(path.cgPath)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.drawPath(using: CGPathDrawingMode.fillStroke)

        context.fillPath()

        UIGraphicsPushContext(context)

        let rectLabel = CGRect(
            origin: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + 6),
            size: size)
        label.draw(in: rectLabel, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(String(format: "%@", Int(entry.y).convertToStringDecimalFormat()))
    }

    public func setLabel(_ newLabel: String) {
        label = newLabel

        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + 20
        size.height = _labelSize.height
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}


public class ResidentChartMarker: ChartMarker {
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(Int(entry.y).convertToStringDecimalFormat()+"人")
    }
}

public class OccupancyRateChartMarker: ChartMarker {
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel("\(Int(entry.y))%")
    }
}

public class ManagedUnitChartMarker: ChartMarker {
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(Int(entry.y).convertToStringDecimalFormat()+"戸")
    }
}
