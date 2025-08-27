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
        .foregroundStyle(.primary)
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
            Text("loremIpsum")
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
}
