import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  get format => DateFormat('dd MMM yyyy hh:mm aaa').format(this);
  get onlyDate => DateFormat('dd MMM yyyy').format(this);
  get timeDateFormat => DateFormat('hh:mm aaa (dd MMM yyyy)').format(this);
  get timeDateFormatToServer => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
}

String convertTimeStampToDisplayTimeString(int time) {
  DateTime now = DateTime.now();
  DateFormat format = DateFormat('HH:mm a');
  DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
  Duration diff = now.difference(date);
  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    return format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      return '1 day ago';
    } else {
      return '${diff.inDays} days ago';
    }
  } else {
    if (diff.inDays == 7) {
      return '1 week ago';
    } else {
      return '${(diff.inDays / 7).floor()} weeks ago';
    }
  }
}
