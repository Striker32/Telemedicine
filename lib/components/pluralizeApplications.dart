String pluralizeApplications(int count) {
  final lastDigit = count % 10;
  final lastTwoDigits = count % 100;

  if (lastDigit == 1 && lastTwoDigits != 11) {
    return '$count заявка';
  } else if (lastDigit >= 2 && lastDigit <= 4 && (lastTwoDigits < 10 || lastTwoDigits > 20)) {
    return '$count заявки';
  } else {
    return '$count заявок';
  }
}
