import SwiftData
import Foundation


typealias Row = Array<Value>
typealias RowSet = Array<Row>

class Html {
    /// textMap: a 2D array of text values that I format differently from the rest.
    /// textMap is an unpivoted table. Dates are row headers.
    /// measureMap: a 2D array of non-text values. This data is pivoted, dates are column headers.
    static func generateHtml(for textMap: Dictionary<String, RowSet>,
                             and measureMap: Dictionary<String, RowSet>,
                             weekEnding: Date) -> String {
        getTemplate()
            .replacingOccurrences(of: "{{date}}", with: weekEnding.toString())
            .replacingOccurrences(of: "{{text}}", with: textMap.toHtml())
            .replacingOccurrences(of: "{{measures}}", with: measureMap.toHtml())
    }
    
    static func tabulate(_ name: String, from data: RowSet) -> String {
        return [MarkupTag(for: MarkupTag.heading(1), withText: name).toString(), .newline,
                MarkupTag.tabulate(data).toString()].merged
    }
    
    static func getTemplate() -> String {
        guard let template = Bundle.main.url(forResource: "template", withExtension: "html"),
              let html = try? String(contentsOf: template, encoding: .utf8) else {
            return .nothing
        }
        return html
    }
}


// HTML tag data structure. Only needed this to represent the DOM tree.
class MarkupTag {
    /// "classNames" is for CSS class names that go in the class="" part of markup. Not a fan of that name for the variable...
    /// "content" is the data part that goes in the middle of the tag. E.g. "blah" in <div>blah</div>
    /// "children" are the markup nodes that are within this one. E.g. <span></span> in <div><span>1</span></div>
    var name: String
    var content: String
    var classNames: String
    var style: String
    var children: [MarkupTag]
    
    init(for name: String = .nothing, withText content: String = .nothing, classNames: String = .nothing,
         style: String = .nothing, children: [MarkupTag] = []) {
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
    
    // What does this do? You might ask. Read the name, I might say.
    // It makes the start tag e.g. <span class="...">
    // The regular way would probably be to make Swift look like HTML.
    func makeStartTag(withStyle: Bool = true, withClass: Bool = true) -> String {
        [.bracketOpen, name,
         (withClass && not(classNames.isEmpty)
              ? [.space, .CLASS, .equals, .quote, classNames, .quote].merged
              : .nothing ),

         (withStyle && not(style.isEmpty)
              ? [.space, .STYLE, .equals, .quote, style, .quote].merged
              : .nothing),

         .bracketClose].merged
    }
    
    func makeEndTag() -> String {
        [.bracketOpen, .forwardSlash, name, .bracketClose].merged
    }
    
    // Returning self to enable chaining [E.g. tag.apply(classes...).addStyle(styles...).toString()]
    func apply(classes names: String...) -> MarkupTag {
        if names.spaced.isEmptyOrWhitespace() { return self }
        self.classNames += names.spaced + .space
        return self
    }
    
    func addStyle(from styles: Dictionary<String, String>) -> MarkupTag {
        self.style += styles.map({ key, value in
            [key, .colon, value, .semicolon].merged
        }).spaced + .space
        return self
    }
    // What do I even say apart from my running commentary?
    // It's all in the code already.
}

extension MarkupTag {
    // This enables all the expressive code
    static let TABLE_CELL: String = "td"
    static let TABLE_HEADER: String = "th"
    static let TABLE_ROW: String = "tr"
    static let TABLE_BODY: String = "tbody"
    static let TABLE: String = "table"
    static let DIV: String = "div"
    static let SPAN: String = "span"
    static let LINE_BREAK: String = "<br/>"
    
    static var HEADING : (Int) -> String { heading }
    static func heading(_ priority: Int) -> String {
        "h\(priority)"
    }
    
    /// Creates an HTML table from matrix, the passed in 2D array
    static func tabulate(_ matrix: RowSet) -> MarkupTag {
        // I love the part where you use all the coolness you built.
        // I'll translate this code to English, relying on the words in code.
        
        // Make the table markup tag, with children:
        // Make the table body tag, with children:
        // Make a row tag for every row in the matrix with children:
        // Make a cell tag for every cell in the row
        MarkupTag(for: TABLE, children: [
            MarkupTag(for: TABLE_BODY,
                      children: matrix.enumerated().map({ row_number, row in
                MarkupTag(for: TABLE_ROW, children: row.map({cell in
                    makeCell(cell, isHeader: row_number == 0)
                }))
            }))
        ]).apply(classes: getStyle(of: TABLE))
    }
    
    static func makeCell(_ value: Value, isHeader: Bool = false) -> MarkupTag {
        MarkupTag(for: isHeader ? TABLE_HEADER : TABLE_CELL,
                  withText: value.kind == .stringArray ? .nothing : value.toString(),
                  children: value.kind == .stringArray ? getContentForArray(value) : []
        ).apply(classes: getStyle(for: value, of: TABLE_CELL))
    }
    
    // This replaces switch-case. I think it looks cleaner. It has a small performance benefit too.
    static func getStyle(for value: Value = .nothing, of tag: String = .nothing) -> String {
        if tag.equals(TABLE) {
            return "simple-table"
        }
        return stylers[value.kind].orDefaultTo({ _ in .nothing }) (value)
    }
    
    static func getContentForArray(_ values: Value) -> [MarkupTag] {
        values.asStringArray.enumerated().map({ index, value in
            MarkupTag(for: SPAN, withText: value)
                .apply(classes: "selected-value", colourClasses[index])
        })
    }
    
    nonisolated(unsafe) static let stylers: Dictionary<Value.Kind, (Value) -> String> = [
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
    
    // I've restricted the super specific code to this file. I'll handle them later (TM)
    static let intStyle: Dictionary<Int, String> = [
        3: "block-color-grey_background",
        6: "block-color-blue_background",
        10: "block-color-orange_background"
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

extension Dictionary where Key == String, Value == RowSet {
    func toHtml() -> String {
        self.sorted(by: { $0.key < $1.key })
            .map({name, data in [
                MarkupTag(for: MarkupTag.heading(3), withText: name).toString(),
                MarkupTag(for: MarkupTag.SPAN, children: [
                    MarkupTag(for: MarkupTag.SPAN, children: [MarkupTag.tabulate(data)])
                        .addStyle(from: ["display": "table-cell"])
                ])
                .addStyle(from: ["width": "100%", "display": "table"])
                .toString(),
                .newline
            ].merged
            }).merged
    }
}
