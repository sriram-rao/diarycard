import SwiftUI

struct ErrorView: View {
    let message: String?
    let onDismiss: () -> Void
    
    var body: some View {
        Group {
            if let message = message {
                VStack {
                    Spacer()
                    errorToast(message: message)
                }
            }
        }
    }
    
    private func errorToast(message: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Error")
                    .font(.headline)
                    .foregroundStyle(.red)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("✕") {
                onDismiss()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    ErrorView(message: "Something went wrong with your request") {
        print("Error dismissed")
    }
}