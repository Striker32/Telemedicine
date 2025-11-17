import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // УДАЛЕНО: UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    // Плагин делает это сам при регистрации.
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// 3. Расширение для обработки уведомлений (Foreground и Tap)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Метод для показа уведомлений, когда приложение активно (Foreground)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                        willPresent notification: UNNotification, 
                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Разрешаем показ алерта, бэйджа и звука. Flutter_local_notifications
        // сам проверит настройки defaultPresentAlert из Dart.
        completionHandler([.alert, .badge, .sound]) 
    }
    
    // Метод для обработки нажатия на уведомление
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                        didReceive response: UNNotificationResponse, 
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // ИСПРАВЛЕНО: Используем актуальный API
        FlutterLocalNotificationsPlugin.handleNotificationAction(response)
        
        completionHandler()
    }
}