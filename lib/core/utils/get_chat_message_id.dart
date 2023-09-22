const String dGLetters =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

String getChatMessageId(num time) {
  int timeId = (time) as int;
  if (timeId < 62) {
    return dGLetters[timeId];
  }
  String res = '';
  int remainder = 0;
  while (timeId > 61) {
    remainder = timeId % 62;
    timeId ~/= 62;
    res += dGLetters[remainder];
  }
  res += dGLetters[remainder];
  return res;
}
