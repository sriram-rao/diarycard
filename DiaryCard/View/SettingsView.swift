import SwiftUI

struct SettingsView: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                notificationSection
                footerSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                doneButton
            }
        }
    }

    private var notificationSection: some View {
        Section(header: Text("Daily Reminder")) {
            Toggle("Enable reminder", isOn: $notificationManager.isEnabled)

            if notificationManager.isEnabled {
                DatePicker(
                    "Time",
                    selection: $notificationManager.reminderTime,
                    displayedComponents: .hourAndMinute
                )

                TextField("Title", text: $notificationManager.notificationTitle)

                TextField("Message", text: $notificationManager.notificationBody, axis: .vertical)
                    .lineLimit(2...4)
            }
        }
    }

    private var footerSection: some View {
        Section(footer: Text("Get a daily reminder to fill out your diary card")) {
            EmptyView()
        }
    }

    @ToolbarContentBuilder
    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
                dismiss()
            }
        }
    }
}

#Preview {
    SettingsView()
}
