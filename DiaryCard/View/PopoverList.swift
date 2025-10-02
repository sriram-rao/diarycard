import SwiftUI

struct PopoverList: View {
    @Binding var selected: [String]
    let full: [String]
    
    var body: some View {
        GlassEffectContainer(spacing: 8) {
            VStack(spacing: 8) {
                ForEach(full, id: \.self) { skill in
                    SkillToggleButton(
                        skill: skill,
                        isSelected: selected.contains(skill),
                        action: { toggleSkill(skill) }
                    )
                }
            }
            .frame(maxHeight: 400)
        }
        .accessibilityLabel("Skill selection list")
    }
    
    private func toggleSkill(_ skill: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selected.contains(skill) {
                selected.removeAll { $0 == skill }
            } else {
                selected.append(skill)
            }
        }
    }
}

struct SkillToggleButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let skill: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(skill)
                    .font(isSelected ? .body.bold() : .body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
            }
            .foregroundStyle(isSelected ? Color.themed(colorScheme, light: .blue, dark: .sky) : .secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(LiquidGlassButtonStyle(isSelected: isSelected))
        .accessibilityLabel("\(skill), \(isSelected ? "selected" : "not selected")")
        .accessibilityHint("Tap to \(isSelected ? "deselect" : "select")")
    }
}

struct LiquidGlassButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                ZStack {
                    // Background fill with opacity
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.clear : Color.gray.opacity(0.05))
                        .opacity(0.01)
                    
                    // Stroke without opacity
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.themed(colorScheme, light: .blue, dark: .sky): .clear, lineWidth: 1)
                }
            }
            .glassEffect(
                isSelected ? .regular.tint(.clear).interactive() : .clear.interactive(),
                in: .rect(cornerRadius: 12)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct PopoverButton: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let types: [String]
    let action: () -> Void

    var body : some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.3)) { action() } }) {
            HStack {
                Text("\(title) - \(types.count) selected")
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Image(systemName: "plus.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .buttonStyle(.glass)
        .controlSize(.small)
        .accessibilityLabel("Select skills")
        .accessibilityHint("Opens skill selection interface")
        .accessibilityValue(types.isEmpty ? "No skills selected" : "\(types.count) skills selected")
    }
    
    private var displayText: String {
        if types.isEmpty {
            return "Add Skills"
        } else {
            return ListFormatter().string(from: types) ?? types.joined(separator: ", ")
        }
    }
}

// TapBackground replaced with native SwiftUI .background() modifier
// Use .background(.regularMaterial) or similar instead

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


#Preview("Popover List") {
    @Previewable @State var selected: [String] = Card.getSampleData().first!.get(key: "skills.distress tolerance").asStringArray
    VStack {
        Text("Selected: \(selected.joined(separator: ", "))")
            .padding()
        
        PopoverList(selected: $selected, full: Skills["skills.distress tolerance"]! )
            .frame(maxWidth: 300, maxHeight: 400)
            .padding()
    }
    .background(.regularMaterial)
}


#Preview("Popover Button") {
    @Previewable @State var selected: Bool = false
    VStack {
        Text("Button tapped: \(String(selected))")
            .padding()
        
        PopoverButton(title: "Test", types: ["Mindfulness", "Distress Tolerance"], action: { selected.toggle() })
            .frame(maxWidth: 250)
            .padding()
    }
    .background(.regularMaterial)
}
