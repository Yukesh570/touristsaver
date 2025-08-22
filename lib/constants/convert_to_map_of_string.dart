Map<String, String> convertToMapOfStrings(Map<String, dynamic> originalMap) {
  Map<String, String> stringMap = {};
  originalMap.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      // Recursively convert nested maps
      stringMap[key] = convertToMapOfStrings(value).toString();
    } else {
      // Convert other values to strings
      stringMap[key] = value.toString();
    }
  });
  return stringMap;
}
