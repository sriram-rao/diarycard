import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    private let notificationIdentifier = "daily-diary-reminder"

    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "notificationEnabled")
            if isEnabled {
                scheduleNotification()
            } else {
                cancelNotification()
            }
        }
    }

    @Published var reminderTime: Date {
        didSet {
            UserDefaults.standard.set(reminderTime, forKey: "notificationTime")
            if isEnabled {
                scheduleNotification()
            }
        }
    }

    @Published var notificationTitle: String {
        didSet {
            UserDefaults.standard.set(notificationTitle, forKey: "notificationTitle")
            if isEnabled {
                scheduleNotification()
            }
        }
    }

    @Published var notificationBody: String {
        didSet {
            UserDefaults.standard.set(notificationBody, forKey: "notificationBody")
            if isEnabled {
                scheduleNotification()
            }
        }
    }

    private init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: "notificationEnabled")
        self.reminderTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date ?? {
            let calendar = Calendar.current
            var components = DateComponents()
            components.hour = 20
            components.minute = 0
            return calendar.date(from: components) ?? Date()
        }()
        self.notificationTitle = UserDefaults.standard.string(forKey: "notificationTitle") ?? "Time to fill your diary card"
        self.notificationBody = UserDefaults.standard.string(forKey: "notificationBody") ?? "Take a moment to reflect on your day"
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            Task { @MainActor in
                if !granted {
                    self?.isEnabled = false
                }
            }
        }
    }

    func scheduleNotification() {
        cancelNotification()

        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}
