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
    
    // ВАЖНО: Устанавливаем делегата, чтобы плагин мог работать с Foreground
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// ЭТОТ БЛОК ДОЛЖЕН БЫТЬ ПЕРЕХВАЧЕН ПЛАГИНОМ АВТОМАТИЧЕСКИ, 
// НО ЕСЛИ ЕСТЬ ПРОБЛЕМЫ, ДОБАВЬТЕ ЕГО ДЛЯ РУЧНОЙ ПЕРЕДАЧИ
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 1. Показ уведомления в Foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                        willPresent notification: UNNotification, 
                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(
            // Плагин ожидает, что вы передадите ему эти опции. 
            // Это разрешает показ уведомлений, когда приложение активно.
            // Плагин сам решит, показывать ли их на основе Dart-настроек.
            [.alert, .badge, .sound]
        )
    }
    
    // 2. Обработка нажатия на уведомление
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                         didReceive response: UNNotificationResponse, 
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Обязательная передача нажатия обратно в Flutter.
        FlutterLocalNotificationsPlugin.handleNotificationAction(response)
        
        completionHandler()
    }
}