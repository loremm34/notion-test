// абстрактный класс для работы с уведомлениями
abstract class NotificationRepository {
  Future<void> requestPermissions();
  Future<void> initNotifications();
  Future<void> scheduleNotification(DateTime targetDateTime, String noteTitle);
}
