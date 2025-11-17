import UIKit
import Flutter
import flutter_local_notifications // 1. Импортируем пакет

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 2. Устанавливаем делегата для обработки уведомлений
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// 3. Расширение для обработки уведомлений (Foreground и Tap)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Метод для показа уведомлений, когда приложение активно (Foreground)
    // Это заставляет iOS отображать баннер, звук, бэйдж.
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                        willPresent notification: UNNotification, 
                                        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Этот вызов важен. Он гарантирует, что flutter_local_notifications 
        // обработает уведомление в соответствии с настройками Dart (defaultPresentAlert и т.д.)
        // Важно: В этом методе не нужно явно вызывать FlutterLocalNotificationsPlugin.
        // Вместо этого просто разрешаем показ, и плагин обрабатывает его.
        
        completionHandler([.alert, .badge, .sound]) // Разрешаем показ алерта, бэйджа и звука
    }
    
    // Метод для обработки нажатия на уведомление
    override func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                        didReceive response: UNNotificationResponse, 
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Передаем ответ плагину для обработки Payload
        FlutterLocalNotificationsPlugin.didReceiveResponse(response)
        
        completionHandler()
    }
}