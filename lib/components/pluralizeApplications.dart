String pluralizeApplications(String count) {
  // пробуем преобразовать строку в число
  final number = int.tryParse(count);
  if (number == null) {
    // если не получилось — сразу возвращаем "заявок"
    return '$count заявок';
  }

  final lastDigit = number % 10;
  final lastTwoDigits = number % 100;

  if (lastDigit == 1 && lastTwoDigits != 11) {
    return '$count заявка';
  } else if (lastDigit >= 2 &&
      lastDigit <= 4 &&
      (lastTwoDigits < 10 || lastTwoDigits > 20)) {
    return '$count заявки';
  } else {
    return '$count заявок';
  }
}
