//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

struct RectangleProperties {
    let size: CGSize
    let cornerRadius: CGFloat
}

struct PolygonProperties {
    let size: CGSize
    let numOfSides: Int
    let cornerRadius: CGFloat
    let rotationAngle: CGFloat
    let borderWidth: CGFloat
}

struct ImageProperties {
    let size: CGSize
    let fillColor: UIColor
    let borderColor: UIColor
    let borderWidth: CGFloat
}

class ImageProviderImpl {
    private func image(
        with properties: ImageProperties,
        path: UIBezierPath
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: properties.size)

        return renderer.image { context in
            let cgContext = context.cgContext

            cgContext.setStrokeColor(properties.borderColor.cgColor)
            cgContext.setLineWidth(properties.borderWidth)

            path.addClip()

            let gradientColors = [
                properties.fillColor.darken(by: 0.7).cgColor,
                properties.fillColor.cgColor
            ]

            if let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: gradientColors as CFArray,
                locations: nil
            ) {
                cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(
                        x: properties.size.width / 2.0,
                        y: properties.size.height
                    ),
                    end: CGPoint(
                        x: properties.size.width / 2.0,
                        y: 0.0
                    ),
                    options: CGGradientDrawingOptions()
                )
            }

            path.stroke()
        }
    }

    private func polygonPath(with properties: PolygonProperties) -> UIBezierPath {
        let path = UIBezierPath()
        let theta = CGFloat(2.0 * Double.pi) / CGFloat(properties.numOfSides)
        let width = min(properties.size.width, properties.size.height)
        let center = CGPoint(x: width / 2.0, y: width / 2.0)
        let radius = (width - properties.borderWidth + properties.cornerRadius
                      - (cos(theta) * properties.cornerRadius)) / 2.0
        var angle = properties.rotationAngle
        let corner = CGPoint(
            x: center.x + (radius - properties.cornerRadius) * cos(angle),
            y: center.y + (radius - properties.cornerRadius) * sin(angle)
        )

        path.move(to:
                    CGPoint(
                        x: corner.x + properties.cornerRadius * cos(angle + theta),
                        y: corner.y + properties.cornerRadius * sin(angle + theta)
                    )
        )

        (0 ..< properties.numOfSides).forEach { _ in
            angle += theta

            let corner = CGPoint(
                x: center.x + (radius - properties.cornerRadius) * cos(angle),
                y: center.y + (radius - properties.cornerRadius) * sin(angle)
            )
            let tip = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            let start = CGPoint(
                x: corner.x + properties.cornerRadius * cos(angle - theta),
                y: corner.y + properties.cornerRadius * sin(angle - theta)
            )
            let end = CGPoint(
                x: corner.x + properties.cornerRadius * cos(angle + theta),
                y: corner.y + properties.cornerRadius * sin(angle + theta)
            )

            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }

        path.close()

        let bounds = path.bounds
        let transform = CGAffineTransform(
            translationX: -bounds.origin.x + properties.borderWidth / 2.0,
            y: -bounds.origin.y + properties.borderWidth / 2.0
        )
        path.apply(transform)

        return path
    }
}

extension ImageProviderImpl: ImageProvider {
    func fallingNodeImage(
        size: CGSize,
        color: UIColor
    ) -> UIImage {
        let properties = PolygonProperties(
            size: size,
            numOfSides: 6,
            cornerRadius: 2.0,
            rotationAngle: 0.0,
            borderWidth: 1.0
        )
        let imageProperties = ImageProperties(
            size: size,
            fillColor: color,
            borderColor: .black,
            borderWidth: 1.0
        )

        let path = polygonPath(with: properties)

        return image(
            with: imageProperties,
            path: path
        )
    }

    func solutionNodeImage(
        size: CGSize,
        color: UIColor
    ) -> UIImage {
        let properties = RectangleProperties(
            size: size,
            cornerRadius: 4.0
        )
        let imageProperties = ImageProperties(
            size: size,
            fillColor: color,
            borderColor: .black,
            borderWidth: 1.0
        )

        let path = UIBezierPath(
            roundedRect: CGRect(origin: .zero, size: properties.size),
            cornerRadius: properties.cornerRadius
        )

        return image(
            with: imageProperties,
            path: path
        )
    }
}
