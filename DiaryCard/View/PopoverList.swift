import SwiftUI

struct PopoverList: View {
    @Binding var selected: [String]
    let items: [SkillItem]
    @State private var showingDescription: String? = nil
    
    init(selected: Binding<[String]>, items: [SkillItem]) {
        self._selected = selected
        self.items = items
    }
    
    var body: some View {
        GlassEffectContainer(spacing: 8) {
            VStack(spacing: 8) {
                ForEach(items, id: \.name) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        SkillToggleButton(
                            skill: item.name,
                            description: item.description,
                            isSelected: selected.contains(item.name),
                            showingDescription: showingDescription == item.name,
                            action: { toggleSkill(item.name) },
                            onLongPress: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if showingDescription == item.name {
                                        showingDescription = nil
                                    } else {
                                        showingDescription = item.name
                                    }
                                }
                            }
                        )
                    }
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
    @GestureState private var isPressing = false
    
    let skill: String
    let description: String
    let isSelected: Bool
    let showingDescription: Bool
    let action: () -> Void
    let onLongPress: () -> Void

    // MARK: - Styling Vars
    private var headerForeground: Color {
        isSelected ? Color.themed(colorScheme, light: .blue, dark: .cyan) : .secondary
    }

    private var headerFill: Color {
        isSelected ? .clear : Color.gray.opacity(0.05)
    }

    private var headerBorderColor: Color { 
        isSelected ? Color.themed(colorScheme, light: .blue, dark: .cyan) : Color.secondary.opacity(0.3)
    }
    
    private var descriptionBorderColor: Color { Color.secondary.opacity(0.3) }

    private var strokeStyle: StrokeStyle { StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round) }

    // MARK: - Shapes
    private var headerShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 12,
            bottomLeadingRadius: showingDescription ? 0 : 12,
            bottomTrailingRadius: showingDescription ? 0 : 12,
            topTrailingRadius: 12
        )
    }

    private var descriptionShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 12,
            bottomTrailingRadius: 12,
            topTrailingRadius: 0
        )
    }
    
    // MARK: - Modular Subviews
    private var infoIcon: some View {
        Image(systemName: "info.circle")
            .font(.caption)
            .foregroundStyle(.secondary)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onLongPress()
                }
            }
    }

    private var selectionIcon: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.title3)
    }

    private var headerView: some View {
        HStack {
            Text(skill)
                .font(isSelected ? .body.bold() : .body)
                .frame(maxWidth: .infinity, alignment: .leading)

            infoIcon

            Spacer()

            selectionIcon
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(headerForeground)
        .scaleEffect(isPressing ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressing)
        .background {
            headerShape
                .fill(headerFill.opacity(0.01))
        }
        .overlay {
            headerShape
                .strokeBorder(headerBorderColor, lineWidth: 1)
        }
        .clipShape(headerShape)
        .compositingGroup()
        .glassEffect(
            isSelected ? .regular.tint(.clear).interactive() : .clear.interactive(),
            in: .rect(cornerRadius: 12)
        )
    }

    private var descriptionView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(.footnote)
                .foregroundStyle(.black.opacity(0.85))
                .padding(.top, 2)

            Text(description)
                .font(.callout)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ZStack {
                descriptionShape
                    .fill(Color.gray.opacity(0.08))
                
                descriptionShape
                    .strokeBorder(descriptionBorderColor, lineWidth: 1)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            if showingDescription {
                descriptionView
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    // Detect vertical swipe (up or down)
                    if abs(value.translation.height) > abs(value.translation.width) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            onLongPress()
                        }
                    }
                }
        )
        .onLongPressGesture(minimumDuration: 0.5) {
            onLongPress()
        }
        .accessibilityLabel("\(skill), \(isSelected ? "selected" : "not selected")")
        .accessibilityHint("Tap to \(isSelected ? "deselect" : "select"), swipe or long press for description")
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
                    .foregroundStyle(.blue)
            }
            .padding(10)
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
    let items = Skills["skills.distress tolerance"] ?? []
    VStack {
        Text("Selected: \(selected.joined(separator: ", "))")
            .padding()
        
        PopoverList(selected: $selected, items: items)
            .frame(maxWidth: 300, maxHeight: 400)
            .padding()
    }
    .background(.regularMaterial)
}


#Preview("Skill Toggle Button") {
    @Previewable @State var isSelected: Bool = false
    @Previewable @State var showingDescription: Bool = false
    
    VStack(spacing: 20) {
        Text("Selected: \(String(isSelected))")
            .font(.caption)
            .foregroundStyle(.secondary)
        
        Text("Showing Description: \(String(showingDescription))")
            .font(.caption)
            .foregroundStyle(.secondary)
        
        SkillToggleButton(
            skill: "Mindfulness",
            description: "The practice of being present and fully engaged with whatever we're doing at the moment — free from distraction or judgment, and aware of where we are and what we're doing.",
            isSelected: isSelected,
            showingDescription: showingDescription,
            action: { 
                isSelected.toggle() 
            },
            onLongPress: { 
                showingDescription.toggle()
            }
        )
        .frame(maxWidth: 300)
    }
    .padding()
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

