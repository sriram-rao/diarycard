import SwiftUI

struct PopoverList: View {

    @Binding var selected: [String]
    let full: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(full, id: \.self) {skill in
                let skillSelected = selected.contains(skill)
                let style = getStyle(for: skillSelected)
                
                Button {
                    skillSelected ? remove(skill) : add(skill)
                } label: {
                    showButtonLabel(for: skill, isSelected: skillSelected)
                }
                .padding(.all, 10)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(style.buttonFillColor)
                        .stroke(.blue, lineWidth: style.lineStrokeWidth)
                )
                .frame(maxWidth: 250)
            }
        }
        .focusable(true, interactions: .activate)
    }
    
    func showButtonLabel(for skill: String, isSelected: Bool) -> some View {
        let style = getStyle(for: isSelected)
        return Group {
            Text(skill).foregroundStyle(style.labelTextColor)
            Spacer()
            Image(systemName: style.imageName)
                .foregroundStyle(style.imageColor)
        }
    }
    
    func getStyle(for skillSelected: Bool) -> Style {
        Style(labelTextColor: skillSelected ? .blue : .secondary,
              buttonFillColor: skillSelected ? Color.white : .gray.opacity(0.1),
              lineStrokeWidth: skillSelected ? 1 : 0,
              imageName: skillSelected ? "minus.circle" : "plus.circle.fill",
              imageColor: skillSelected ? .blue : .gray)
    }
    
    func add(_ skill: String) {
        $selected.wrappedValue.append(skill)
    }
    
    func remove(_ skill: String) {
        $selected.wrappedValue.removeAll { $0 == skill }
    }
    
    struct Style {
        var labelTextColor: Color
        var buttonFillColor: Color
        var lineStrokeWidth: CGFloat
        var imageName: String
        var imageColor: Color
    }
}

struct PopoverButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let types: [String]
    let action: () -> Void

    var body : some View {
        Button(action: { withAnimation { action() } },
               label: {
            let skills = ListFormatter().string(from: types).orUse(.nothing)
            Text(not(skills.isEmpty) ? skills : "Add Skills")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .lineLimit(1)
        })
        .foregroundStyle(colorScheme == ColorScheme.dark ? .buttercup : .oxblood)
        .focusable(true, interactions: .activate)
    }
}

struct TapBackground: View {
    let tapAction: () -> Void
    
    var body: some View {
        Rectangle().fill(Color(.systemBackground).opacity(0.4)) 
            .blur(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture { withAnimation { tapAction() } }
    }
}

struct Toast: View {
    let text: String
    let level: Category = .info
    
    var body: some View {
        ZStack{
            Text(loremIpsum)
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 15)
                    .fill(getFillColor().opacity(0.8))
                    .frame(maxWidth: 370, maxHeight: 150)
                    .overlay(Text(text)
                        .padding(15)
                        .font(.headline)
                        .foregroundStyle(.black))
            }
        }
    }
    
    let levelColorMap: [Category: Color] = [
        .error: .red,
        .warning: .orange,
        .success: .green,
        .info: .blue
    ]
    
    func getFillColor() -> Color {
        levelColorMap[level].orUse(.blue)
    }
    
    
    
    var loremIpsum: String {
        """
What is Lorem Ipsum?

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
Why do we use it?

It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).

Where does it come from?

Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
"""
    }
}
