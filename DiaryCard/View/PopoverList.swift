import SwiftUI

struct PopoverList: View {
    @State private var showPopover: Bool = false
    @Binding var selected: [String]
    let full: [String]
    
    var body: some View {
        ZStack {
            VStack(spacing: 1) {
                ForEach(full, id: \.self) {skill in
                    let skillSelected = selected.contains(skill)
                    HStack {
                        Text(skill)
                        Spacer()
                        Button {
                            print("Selected: \(selected.description)")
                            skillSelected ? $selected.wrappedValue.removeAll { $0 == skill } :
                            $selected.wrappedValue.append(skill)
                            print("Final: \(selected.description)")
                        } label: {
                            showButtonLabel(skillSelected: skillSelected)
                        }
                    }.padding(.all, 10)
                        .background(Rectangle().fill(( skillSelected ? Color.bubblegum : .sky).opacity(0.8)).cornerRadius(10))
                        .frame(maxWidth: 200)
                        .zIndex(2)
                }
            }
            .zIndex(1)
        }.ignoresSafeArea()
    }
    
    func showButtonLabel(skillSelected: Bool) -> some View {
        return Image(systemName: skillSelected ? "minus.circle.fill"
                     : "plus.circle.fill")
        .foregroundStyle(skillSelected ? .sky : .bubblegum)
        .padding(.horizontal, 5)
        .frame(width: 30, height: 20)
        .background(.red)
    }
}

#Preview {
    @Previewable @State var selected: [String] = Card.getSampleData().first!.get(key: "skills.distress tolerance").asStringArray
    Text("Live View: \(selected)")
    PopoverList(selected: $selected, full: ListSchemas.getSampleData().get("skills.distress tolerance"))
}
