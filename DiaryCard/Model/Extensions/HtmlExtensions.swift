import Foundation
import SwiftData

typealias Row = [Value]
typealias RowSet = [Row]

class Html {
    /// textMap: a 2D array of text values that I format differently from the rest.
    /// textMap is an unpivoted table. Dates are the row headers.
    /// measureMap: a 2D array of non-text values. This data is pivoted, dates are the column headers.
    static func generateHtml(
        for textMap: [String: RowSet],
        and measureMap: [String: RowSet],
        weekEnding: Date
    ) -> String {
        getTemplate()
            .replacingOccurrences(of: "{{date}}", with: weekEnding.toString())
            .replacingOccurrences(of: "{{text}}", with: textMap.toHtml())
            .replacingOccurrences(of: "{{measures}}", with: measureMap.toHtml())
    }

    static func getTemplate() -> String {
        guard let template = Bundle.main.url(forResource: "template", withExtension: "html"),
            let html = try? String(contentsOf: template, encoding: .utf8)
        else {
            return .nothing
        }
        return html
    }
}

// HTML tag data structure. Need just this to represent the DOM tree.
class MarkupTag {
    /// "classNames" is for CSS class names that go in the class="" part of markup. Not a fan of that name for the variable...
    /// "content" is the data part that goes in the middle of the tag. E.g. "blah" in <div>blah</div>
    /// "children" are the markup nodes that are within this one. E.g. <span>1</span> in <div><span>1</span></div>
    var name: String
    var content: String
    var classNames: String
    var style: String
    var children: [MarkupTag]

    init(
        for name: String = .nothing, withText content: String = .nothing,
        classNames: String = .nothing,
        style: String = .nothing, children: [MarkupTag] = []
    ) {
        self.name = name
        self.content = content
        self.classNames = classNames
        self.style = style
        self.children = children
    }

    func toString() -> String {
        [self.open, self.content, self.children.map({ $0.toString() }).merged, self.close].merged
    }

    var open: String { self.makeStartTag() }
    var close: String { self.makeEndTag() }

    // The start tag i.e.. <span class="...">.
    func makeStartTag(withStyle: Bool = true, withClass: Bool = true) -> String {
        [
            .bracketOpen, name,
            (withClass && not(classNames.isEmpty)
                ? [.space, .CLASS, .equals, .quote, classNames, .quote].merged
                : .nothing),

            (withStyle && not(style.isEmpty)
                ? [.space, .STYLE, .equals, .quote, style, .quote].merged
                : .nothing),

            .bracketClose,
        ].merged
    }

    func makeEndTag() -> String {
        [.bracketOpen, .forwardSlash, name, .bracketClose].merged
    }

    // Returning self to enable chaining [E.g. tag.apply(classes...).addStyle(styles...).toString()]
    func apply(classes names: String...) -> MarkupTag {
        if names.spaced.isBlank() { return self }
        self.classNames += names.spaced + .space
        return self
    }

    func addStyle(from styles: [String: String]) -> MarkupTag {
        self.style +=
            styles.map({ key, value in
                [key, .colon, value, .semicolon].merged
            }).spaced + .space
        return self
    }
}

extension MarkupTag {
    static let TABLE_CELL: String = "td"
    static let TABLE_HEADER: String = "th"
    static let TABLE_ROW: String = "tr"
    static let TABLE_BODY: String = "tbody"
    static let TABLE: String = "table"
    static let DIV: String = "div"
    static let SPAN: String = "span"
    static let LINE_BREAK: String = "<br/>"

    static var HEADING: (Int) -> String { heading }
    static func heading(_ priority: Int) -> String {
        "h\(priority)"
    }

    /// Creates an HTML table from matrix, the passed in 2D array
    static func tabulate(_ matrix: RowSet) -> MarkupTag {
        MarkupTag(
            for: TABLE,
            children: [
                MarkupTag(
                    for: TABLE_BODY,
                    children: matrix.enumerated().map({ row_number, row in
                        MarkupTag(
                            for: TABLE_ROW,
                            children: row.map({ cell in
                                makeCell(cell, isHeader: row_number == 0)
                            }))
                    }))
            ]
        ).apply(classes: getStyle(in: TABLE))
    }

    static func makeCell(_ value: Value, isHeader: Bool = false) -> MarkupTag {
        MarkupTag(
            for: isHeader ? TABLE_HEADER : TABLE_CELL,
            withText: value.kind == .stringArray ? .nothing : value.toString(),
            children: value.kind == .stringArray ? getContentForArray(value) : []
        ).apply(classes: getStyle(for: value, in: TABLE_CELL))
    }

    static func getStyle(for value: Value = .nothing, in tag: String = .nothing) -> String {
        if tag.equals(TABLE) {
            return "simple-table"
        }
        return stylers[value.kind].orUse({ _ in .nothing })(value)
    }

    static func getContentForArray(_ values: Value) -> [MarkupTag] {
        values.asStringArray.enumerated().map({ index, value in
            MarkupTag(for: SPAN, withText: value)
                .apply(classes: "selected-value", colourClasses[index])
        })
    }

    nonisolated(unsafe) static let stylers: [Value.Kind: (Value) -> String] = [
        .int: { value in
            for (key, style) in intStyle.sorted(by: { $0.key < $1.key }) {
                if value.asInt <= key {
                    return style
                }
            }
            return .nothing
        },

        .bool: { condition in
            if condition.asBool {
                return "block-color-purple_background"
            }
            return .nothing
        },
    ]

    // TODO: Too specific, should be a config 
    static let intStyle: [Int: String] = [
        3: "block-color-grey_background",
        6: "block-color-blue_background",
        10: "block-color-orange_background",
    ]

    static let colourClasses: [String] = [
        "select-value-color-default",
        "select-value-color-pink",
        "select-value-color-blue",
        "select-value-color-gray",
        "select-value-color-orange",
        "select-value-color-purple",
        "select-value-color-brown",
        "select-value-color-red",
        "select-value-color-green",
    ]
}

extension Dictionary where Key == String, Value == RowSet {
    func toHtml() -> String {
        self.sorted(by: { $0.key < $1.key })
            .map({ name, data in
                [
                    MarkupTag(for: MarkupTag.heading(3), withText: name).toString(),
                    MarkupTag(
                        for: MarkupTag.SPAN,
                        children: [
                            MarkupTag(for: MarkupTag.SPAN, children: [MarkupTag.tabulate(data)])
                                .addStyle(from: ["display": "table-cell"])
                        ]
                    )
                    .addStyle(from: ["width": "100%", "display": "table"])
                    .toString(),
                    .newline,
                ].merged
            }).merged
    }
}

extension String {
    static var bracketOpen: String { "<" }
    static var bracketClose: String { ">" }
    static var CLASS: String { "class" }
    static var STYLE: String { "style" }
}

extension Array where Element == String {
    var merged: String { joined(separator: .nothing) }
    var spaced: String { joined(separator: .space) }
}
