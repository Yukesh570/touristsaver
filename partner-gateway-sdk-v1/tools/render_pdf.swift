import AppKit
import CoreGraphics
import CoreText
import Foundation
import ImageIO

guard CommandLine.arguments.count == 4 else {
    fputs("usage: render_pdf <markdown> <logo> <output.pdf>\n", stderr)
    exit(64)
}

let sourcePath = CommandLine.arguments[1]
let logoPath = CommandLine.arguments[2]
let outputPath = CommandLine.arguments[3]
let markdown = try String(contentsOfFile: sourcePath, encoding: .utf8)

let width: CGFloat = 595.28
let height: CGFloat = 841.89
var pageBox = CGRect(x: 0, y: 0, width: width, height: height)
let navy = NSColor(calibratedRed: 0.067, green: 0.11, blue: 0.267, alpha: 1)
let blue = NSColor(calibratedRed: 0, green: 0.035, blue: 0.996, alpha: 1)
let cyan = NSColor(calibratedRed: 0.094, green: 0.776, blue: 1, alpha: 1)
let green = NSColor(calibratedRed: 0.082, green: 0.58, blue: 0.333, alpha: 1)
let slate = NSColor(calibratedRed: 0.32, green: 0.39, blue: 0.50, alpha: 1)
let pale = NSColor(calibratedRed: 0.953, green: 0.969, blue: 1, alpha: 1)
let border = NSColor(calibratedRed: 0.863, green: 0.898, blue: 0.953, alpha: 1)

guard let consumer = CGDataConsumer(url: URL(fileURLWithPath: outputPath) as CFURL) else {
    fatalError("Unable to create PDF consumer")
}
let metadata: [CFString: Any] = [
    kCGPDFContextTitle: "TouristSaver Partner Gateway SDK V1 — External Developer Review Package",
    kCGPDFContextAuthor: "TouristSaver",
    kCGPDFContextSubject: "Partner architecture, integration, API and security documentation",
    kCGPDFContextCreator: "TouristSaver",
]
guard let pdf = CGContext(consumer: consumer, mediaBox: &pageBox, metadata as CFDictionary) else {
    fatalError("Unable to create PDF context")
}

func style(
    alignment: NSTextAlignment = .left,
    spacing: CGFloat = 2.2,
    before: CGFloat = 0,
    after: CGFloat = 5,
    indent: CGFloat = 0
) -> NSMutableParagraphStyle {
    let value = NSMutableParagraphStyle()
    value.alignment = alignment
    value.lineSpacing = spacing
    value.paragraphSpacingBefore = before
    value.paragraphSpacing = after
    value.headIndent = indent
    return value
}

func text(
    _ value: String,
    font: NSFont,
    color: NSColor,
    paragraph: NSParagraphStyle
) -> NSAttributedString {
    NSAttributedString(string: value, attributes: [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: paragraph,
    ])
}

func draw(_ value: NSAttributedString, in rect: CGRect) {
    pdf.saveGState()
    let setter = CTFramesetterCreateWithAttributedString(value as CFAttributedString)
    let frame = CTFramesetterCreateFrame(
        setter,
        CFRange(location: 0, length: 0),
        CGPath(rect: rect, transform: nil),
        nil
    )
    CTFrameDraw(frame, pdf)
    pdf.restoreGState()
}

func drawLine(_ value: String, font: NSFont, color: NSColor, x: CGFloat, y: CGFloat) {
    let line = CTLineCreateWithAttributedString(
        NSAttributedString(string: value, attributes: [.font: font, .foregroundColor: color])
    )
    pdf.textPosition = CGPoint(x: x, y: y)
    CTLineDraw(line, pdf)
}

func beginPage() {
    pdf.beginPDFPage(nil)
    pdf.setFillColor(NSColor.white.cgColor)
    pdf.fill(pageBox)
    pdf.textMatrix = .identity
}

func headerFooter(page: Int) {
    drawLine("TOURISTSAVER  /  PARTNER GATEWAY SDK V1", font: .systemFont(ofSize: 7.5, weight: .semibold), color: slate, x: 52, y: height - 34)
    pdf.setStrokeColor(border.cgColor)
    pdf.setLineWidth(0.7)
    pdf.move(to: CGPoint(x: 52, y: height - 43))
    pdf.addLine(to: CGPoint(x: width - 52, y: height - 43))
    pdf.move(to: CGPoint(x: 52, y: 38))
    pdf.addLine(to: CGPoint(x: width - 52, y: 38))
    pdf.strokePath()
    drawLine("External developer review — not for production installation", font: .systemFont(ofSize: 7.2), color: slate, x: 52, y: 23)
    drawLine("\(page)", font: .monospacedDigitSystemFont(ofSize: 7.5, weight: .medium), color: slate, x: width - 64, y: 23)
}

func image(at path: String) -> CGImage? {
    guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else { return nil }
    return CGImageSourceCreateImageAtIndex(source, 0, nil)
}

func fitted(_ image: CGImage, in rect: CGRect) -> CGRect {
    let scale = min(rect.width / CGFloat(image.width), rect.height / CGFloat(image.height))
    let size = CGSize(width: CGFloat(image.width) * scale, height: CGFloat(image.height) * scale)
    return CGRect(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2, width: size.width, height: size.height)
}

// Cover
beginPage()
if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [blue.cgColor, cyan.cgColor] as CFArray, locations: [0, 1]) {
    pdf.saveGState()
    pdf.clip(to: CGRect(x: 0, y: height - 18, width: width, height: 18))
    pdf.drawLinearGradient(gradient, start: CGPoint(x: 0, y: height - 9), end: CGPoint(x: width, y: height - 9), options: [])
    pdf.restoreGState()
}
if let logo = image(at: logoPath) {
    pdf.draw(logo, in: fitted(logo, in: CGRect(x: 88, y: 650, width: width - 176, height: 92)))
}
draw(text("PARTNER GATEWAY SDK", font: .systemFont(ofSize: 30, weight: .bold), color: navy, paragraph: style(alignment: .center)), in: CGRect(x: 60, y: 535, width: width - 120, height: 70))
draw(text("VERSION 1", font: .systemFont(ofSize: 14, weight: .bold), color: blue, paragraph: style(alignment: .center)), in: CGRect(x: 60, y: 500, width: width - 120, height: 32))

let status = CGRect(x: 116, y: 438, width: width - 232, height: 38)
pdf.setFillColor(pale.cgColor)
pdf.setStrokeColor(border.cgColor)
pdf.addPath(CGPath(roundedRect: status, cornerWidth: 19, cornerHeight: 19, transform: nil))
pdf.drawPath(using: .fillStroke)
draw(text("DEVELOPER REVIEW  •  NOT FOR PRODUCTION USE", font: .systemFont(ofSize: 9, weight: .bold), color: blue, paragraph: style(alignment: .center)), in: CGRect(x: status.minX + 10, y: status.minY + 10, width: status.width - 20, height: 18))
draw(text("A reusable, secure membership-verification hand-off for TouristSaver strategic partners.", font: .systemFont(ofSize: 15, weight: .medium), color: slate, paragraph: style(alignment: .center, spacing: 5)), in: CGRect(x: 86, y: 335, width: width - 172, height: 72))

let info = CGRect(x: 74, y: 150, width: width - 148, height: 132)
pdf.setFillColor(pale.cgColor)
pdf.addPath(CGPath(roundedRect: info, cornerWidth: 16, cornerHeight: 16, transform: nil))
pdf.fillPath()
draw(text("Prepared for\nExperience Oz and future TouristSaver strategic partners\n\n5 July 2026", font: .systemFont(ofSize: 11, weight: .medium), color: navy, paragraph: style(alignment: .center, spacing: 5)), in: CGRect(x: info.minX + 24, y: info.minY + 25, width: info.width - 48, height: info.height - 42))
drawLine("CONFIDENTIAL PARTNER REVIEW MATERIAL", font: .systemFont(ofSize: 7.5, weight: .semibold), color: slate, x: 52, y: 39)
pdf.endPDFPage()

let sectionTitles = markdown
    .split(separator: "\n")
    .map(String.init)
    .filter { $0.range(of: #"^## \d+\. "#, options: .regularExpression) != nil }
    .map { String($0.dropFirst(3)) }

// Contents
beginPage()
headerFooter(page: 2)
draw(text("Contents", font: .systemFont(ofSize: 25, weight: .bold), color: navy, paragraph: style(after: 14)), in: CGRect(x: 52, y: 718, width: width - 104, height: 60))
var tocY = height - 145
for title in sectionTitles {
    let parts = title.split(separator: ".", maxSplits: 1)
    let number = parts.first.map(String.init) ?? ""
    let label = parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespaces) : title
    drawLine(number, font: .monospacedDigitSystemFont(ofSize: 10.5, weight: .bold), color: blue, x: 58, y: tocY)
    drawLine(label, font: .systemFont(ofSize: 10.5, weight: .medium), color: navy, x: 92, y: tocY)
    tocY -= 38
}
pdf.endPDFPage()

func cleaned(_ value: String) -> String {
    value
        .replacingOccurrences(of: "**", with: "")
        .replacingOccurrences(of: "`", with: "")
}

let bodyStart = markdown.range(of: "## 1. Executive summary")?.lowerBound ?? markdown.startIndex
let bodyMarkdown = String(markdown[bodyStart...])
let body = NSMutableAttributedString()
var code: [String] = []
var inCode = false

func appendCode() {
    guard !code.isEmpty else { return }
    let codeStyle = style(spacing: 1.4, before: 5, after: 10, indent: 10)
    body.append(NSAttributedString(string: code.joined(separator: "\n") + "\n", attributes: [
        .font: NSFont.monospacedSystemFont(ofSize: 7.3, weight: .regular),
        .foregroundColor: navy,
        .backgroundColor: pale,
        .paragraphStyle: codeStyle,
    ]))
    code.removeAll()
}

for raw in bodyMarkdown.split(separator: "\n", omittingEmptySubsequences: false).map(String.init) {
    if raw.hasPrefix("```") {
        if inCode { appendCode() }
        inCode.toggle()
        continue
    }
    if inCode {
        code.append(raw)
        continue
    }
    if raw == "---" || raw.isEmpty {
        body.append(NSAttributedString(string: "\n"))
        continue
    }
    if raw.hasPrefix("## ") {
        body.append(text(String(raw.dropFirst(3)) + "\n", font: .systemFont(ofSize: 18, weight: .bold), color: navy, paragraph: style(spacing: 1, before: 13, after: 7)))
        continue
    }
    if raw.hasPrefix("### ") {
        body.append(text(String(raw.dropFirst(4)) + "\n", font: .systemFont(ofSize: 12.5, weight: .bold), color: green, paragraph: style(spacing: 1, before: 8, after: 4)))
        continue
    }
    if raw.hasPrefix("- ") {
        body.append(text("•  " + cleaned(String(raw.dropFirst(2))) + "\n", font: .systemFont(ofSize: 9.2), color: navy, paragraph: style(after: 2.5, indent: 15)))
        continue
    }
    if raw.range(of: #"^\d+\. "#, options: .regularExpression) != nil {
        body.append(text(cleaned(raw) + "\n", font: .systemFont(ofSize: 9.2), color: navy, paragraph: style(after: 3, indent: 17)))
        continue
    }
    let isLabel = raw.hasPrefix("**") && raw.contains("**  ")
    let font = isLabel ? NSFont.systemFont(ofSize: 9.3, weight: .bold) : NSFont.systemFont(ofSize: 9.3)
    body.append(text(cleaned(raw) + "\n", font: font, color: isLabel ? navy : slate, paragraph: style(after: 5.5)))
}
if inCode { appendCode() }

let setter = CTFramesetterCreateWithAttributedString(body as CFAttributedString)
let contentRect = CGRect(x: 52, y: 55, width: width - 104, height: height - 112)
var offset = 0
var page = 3
while offset < body.length {
    beginPage()
    headerFooter(page: page)
    let frame = CTFramesetterCreateFrame(
        setter,
        CFRange(location: offset, length: 0),
        CGPath(rect: contentRect, transform: nil),
        nil
    )
    pdf.saveGState()
    CTFrameDraw(frame, pdf)
    pdf.restoreGState()
    let visible = CTFrameGetVisibleStringRange(frame)
    pdf.endPDFPage()
    guard visible.length > 0 else { break }
    offset += visible.length
    page += 1
}

pdf.closePDF()
print("Created \(outputPath) with \(page - 1) pages")
