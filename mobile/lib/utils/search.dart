String? findElementToService(List<Map<String, dynamic>> dataList,
    List<Map<String, dynamic>> serviceList, num id, String key) {
  num serviceId;

  for (var item in dataList) {
    if (item['id'] == id) {
      serviceId = item['service_id'];
      for (var item in serviceList) {
        if (item['id'] == serviceId) {
          return item[key];
        }
      }
    }
  }
  return null;
}

List<String> collectLogos(List<Map<String, dynamic>> dataList,
    List<Map<String, dynamic>> serviceList) {
  final Map<int, String> logosByServiceId = {};

  for (final service in serviceList) {
    final int serviceId = service['id'];
    final String logoUrl = service['logo_url'];
    logosByServiceId[serviceId] = logoUrl;
  }

  final List<String> listLogo = [];
  for (final item in dataList) {
    final int serviceId = item['service_id'];
    final String? logoUrl = logosByServiceId[serviceId];
    if (logoUrl != null) {
      listLogo.add(logoUrl);
    }
  }
  return listLogo;
}

List<Map<String, dynamic>> extractUniqueServiceInfo(
    List<Map<String, dynamic>> dataList,
    List<Map<String, dynamic>> serviceList) {
  List<Map<String, dynamic>> listLogo = [];

  for (var item in dataList) {
    final serviceId = item['service_id'];

    bool found = false;
    for (var logoItem in listLogo) {
      if (logoItem['service_id'] == serviceId) {
        found = true;
        break;
      }
    }
    if (!found) {
      final serviceInfo = serviceList
          .firstWhere((service) => service['id'] == serviceId);
      listLogo.add({
        'service_id': serviceId,
        'logo_url': serviceInfo['logo_url'],
        'name': serviceInfo['name'],
        'key': serviceInfo['key'],
      });
    }
  }

  return listLogo;
}
