import SwiftUI

struct PopoverList: View {
    @Binding var selected: [String]
    let full: [String]
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(full, id: \.self) {skill in
                let skillSelected = selected.contains(skill)
                HStack {
                    Button {
                        skillSelected ? $selected.wrappedValue.removeAll { $0 == skill } :
                        $selected.wrappedValue.append(skill)
                    } label: {
                        Text(skill)
                            .foregroundStyle(.black)
                        Spacer()
                        showButtonLabel(skillSelected: skillSelected)
                    }
                }.padding(.all, 10)
                    .background(Rectangle().fill(( skillSelected ? Color.bubblegum : .sky).opacity(0.8)).cornerRadius(10))
                    .frame(maxWidth: 200)
            }
        }
        .focusable(true, interactions: .activate)
    }
    
    func showButtonLabel(skillSelected: Bool) -> some View {
        return Image(systemName: skillSelected ? "minus.circle.fill"
                     : "plus.circle.fill")
        .foregroundStyle(skillSelected ? .sky : .bubblegum)
        .padding(.horizontal, 5)
        .frame(width: 30, height: 20)
    }
}


struct PopoverButton: View {
    let types: [String]
    let action: () -> Void

    var body : some View {
        Button(action: action, label: {
            Text(ListFormatter().string(from: types) ?? "Add skills")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .lineLimit(1)
        })
        .foregroundStyle(Color.oxblood)
        .focusable(true, interactions: .activate)
    }
}
