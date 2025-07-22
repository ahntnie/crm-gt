part of '../core.dart';

class StringUtils {
  static String convertFloorBuildingToString(
      {required AppLocalizations lang, required String floor, required String buildingName}) {
    return '$floor${Utils.isNullOrEmpty(floor) ? '' : ' - '}$buildingName';
  }

  static String replacePathParams(String path, Map<String, String> params) {
    var result = path;
    params.forEach((key, value) {
      if (Utils.isNullOrEmpty(value)) {
        result = result.replaceAll('/{$key}', '');
      } else {
        result = result.replaceAll('{$key}', value);
      }
    });
    return result;
  }

  static String formatStringToCash({
    required dynamic cash,
    String? unit,
  }) {
    if (Utils.isNullOrEmpty(cash)) {
      return "0 VNĐ";
    }
    if (cash is String) {
      cash = double.parse(cash);
    }

    // // Determine the number of decimal places to display, maximum of 3
    // int decimal = cash is double
    //     ? min(3, (cash * 1000 % 10 > 0 ? 3 : 0)) // Checking if there are trailing decimals
    //     : 0;

    // Format the cash value using NumberFormat
    final numberFormat = NumberFormat('#,##0.000', 'en_US');
    String formattedCash = numberFormat.format(cash);

    if (cash is int || cash is double && cash == cash.round()) {
      formattedCash = NumberFormat('#,##0', 'en_US').format(cash);
    }

    // Modify the decimal places in the formatted string
    // if (decimal > 0) {
    //   formattedCash = cash.toStringAsFixed(decimal);
    // }

    if (!Utils.isNullOrEmpty(unit)) {
      formattedCash += " $unit";
    } else {
      formattedCash += " VNĐ";
    }

    return formattedCash;
  }

  static String valueText(value, {String? type, String? unit}) {
    if (type == ValueType.money.name) {
      return formatStringToCash(cash: value);
    } else if (type == ValueType.phoneNumber.name) {
      if (value is String && value.length <= 8) {
        return value
            .toString()
            .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
            .trimRight();
      }

      return value
          .toString()
          .replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)} ")
          .trimRight();
    } else if (type == ValueType.addUnit.name) {
      return formatStringToCash(cash: value, unit: unit);
    } else if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  static String convertGroundNameToString({required String floor, required String buildingName}) =>
      '$buildingName, $floor';

  static String pathWithQueryParams(String path, Map<String, dynamic> params) {
    String result = path;

    final Map<String, String> paramsString =
        params.map((key, value) => MapEntry(key, value.toString()));

    final queryParams = Uri(queryParameters: paramsString).query;

    if (queryParams.isNotEmpty) {
      result += '?$queryParams';
    }

    return result;
  }

  static String capitalizeFirstCharacter({required String s}) {
    return s[0].toUpperCase() + s.substring(1);
  }
}

enum ValueType {
  number,
  string,
  money,
  addUnit,
  phoneNumber,
  ground,
  time,
  dateTime,
}
