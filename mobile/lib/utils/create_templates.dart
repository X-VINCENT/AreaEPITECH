import 'package:src/data/provider/user_provider.dart';

List<Map<String, dynamic>> getAvailableService(
    Map<String, dynamic> userMap, List<Map<String, dynamic>> service) {
  List<Map<String, dynamic>> availableService = [];
  for (var item in service) {
    if (userMap['${item['key']}_id'] != null) {
      availableService.add(item);
    } else if (item['is_oauth'] == false) {
      availableService.add(item);
    }
  }
  return availableService;
}

List<Map<String, dynamic>> selectRandomActions(
    List<Map<String, dynamic>> allActions,
    List<Map<String, dynamic>> availableServices) {
  final selectedActions = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> allActionsCopy = List.from(allActions);

  for (int i = 0; i < 2; i++) {
    if (allActionsCopy.isEmpty) {
      break;
    }

    final currentService = availableServices[i];
    final serviceId = currentService['id'];
    final logo = currentService['logo_url'];

    for (var action in allActionsCopy) {
      if (action['service_id'] == serviceId) {
        action['logo_url'] = logo;
        selectedActions.add(action);
        allActionsCopy.remove(action);
        break;
      }
    }
  }
  return selectedActions;
}

List<Map<String, dynamic>> createAreaService(
    List<Map<String, dynamic>> actions, List<Map<String, dynamic>> reactions) {
  List<Map<String, dynamic>> areasService = [];

  for (var action in actions) {
    for (var reaction in reactions) {
      Map<String, dynamic> controller = {};
      controller['action_logo'] = action['logo_url'];
      controller['reaction_logo'] = reaction['logo_url'];
      controller['action_id'] = action['id'];
      controller['reaction_id'] = reaction['id'];
      controller['name'] = action['name'];
      areasService.add(controller);
    }
  }
  return areasService;
}

void fillTemplates(AuthProvider? auth, ServiceProvider? services) {
  if (services == null || auth == null) {
    return;
  }
  if (auth.getUser() == null || services.getServices() == null) {
    return;
  }
  final availableService =
      getAvailableService(auth.getUser()!, services.getServices()!);
  final currentActions =
      selectRandomActions(services.getActions()!, availableService);
  final currentReactions =
      selectRandomActions(services.getReactions()!, availableService);
  final areasService = createAreaService(currentActions, currentReactions);
  services.setTemplates(areasService);
}
