  
  import 'package:intl/src/intl/date_format.dart';

  class Utils {
    static String formatDateTime(DateTime dateTime, {String locale = 'id'}) {
      return DateFormat('EEEE, dd MMMM yyyy', locale).format(dateTime);
    }  
  }

  