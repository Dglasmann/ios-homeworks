//
//  LocalNotificationService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.08.2026.
//

import UIKit
import UserNotifications

final class LocalNotificationService: NSObject {
    
    //MARK: - Constants
    
    private enum Constants {
        
        static let updatesCategoryId = "updates"
        static let openUpdatesActionId = "openUpdates"
        static let updatesNotificationId = "dailyUpdatesNotification"
        
    }
    
    func registerForLatestUpdatesIfPossible() {
        
        registerUpdatesCategory()
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { [weak self] granted, error in
            
            if let error = error {
                print("Ошибка получения разрешения на уведомления: \(error.localizedDescription)")
                return
            }
            
            guard granted else { return }
            self?.scheduleDailyUpdatesNotification()
            
        }
        
    }
    
    private func scheduleDailyUpdatesNotification() {
        let content = UNMutableNotificationContent()
        content.title = "ВКонтакте"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        content.badge = 1
        
        content.categoryIdentifier = Constants.updatesCategoryId
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: Constants.updatesNotificationId,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Ошибка регистрации уведомления: \(error.localizedDescription)")
            }
            
        }
    }
    
    func registerUpdatesCategory() {
        UNUserNotificationCenter.current().delegate = self
        
        let openUpdatesAction = UNNotificationAction(
            identifier: Constants.openUpdatesActionId,
            title: "Открыть обновления",
            options: [.foreground]
        )
        
        let updatesCategory = UNNotificationCategory(
            identifier: Constants.updatesCategoryId,
            actions: [openUpdatesAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([updatesCategory])
    }
    
}

extension LocalNotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
        case Constants.openUpdatesActionId:
            print("Пользователь нажал 'Открыть обновления' - переходим на экран новостей")
        default:
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
}
