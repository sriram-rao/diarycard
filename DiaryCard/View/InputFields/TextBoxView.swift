//
//  TextFieldView.swift
//  diarycard
//
//  Created by Sriram Rao on 6/26/25.
//
import SwiftUI

struct TextBoxView: View {
    var attribute: Attribute
    
    var body: some View {
        var text: Binding<String> {
            Binding<String>(
                get: { attribute.value },
                set: {newValue in
                    attribute.value = newValue
                }
            )
        }
        
            TextField(attribute.value, text: text, axis: .vertical)
                .textFieldStyle(.plain)
//                .overlay(RoundedRectangle(cornerRadius: 8).stroke(style: StrokeStyle(lineWidth: 1)))
    }
}

#Preview("TextBox") {
    TextBoxView(attribute: Attribute(name: "Comment", value: "Hello, world! Because grammar is important.", type: "String"))
}

#Preview("Number") {
    TextBoxView(attribute: Attribute(name: "Happiness", value: "2", type: "Number"))
}
