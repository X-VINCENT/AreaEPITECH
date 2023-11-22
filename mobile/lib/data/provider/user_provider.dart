import 'package:flutter/material.dart';
import 'package:src/requests/create_area_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:src/styles/app_theme.dart';
import 'package:src/data/constants.dart';

class AuthProvider {
  String? token;
  Map<String, dynamic> ? user;

  void setToken(String newToken) {
    token = newToken;
  }

  String? getToken() {
    return token;
  }

  void setUser(Map<String, dynamic> newUser) {
    user = newUser;
  }

  Map<String, dynamic>? getUser() {
    return user;
  }

  void deleteByName(String name) {
    user?[name] = null;
  }

  void addByName(String name, dynamic value) {
    user?[name] = value;
  }

  void deleteProvider() {
    user = null;
  }
}

class ServiceProvider {
  List<Map<String, dynamic>>? services;
  List<Map<String, dynamic>>? actions;
  List<Map<String, dynamic>>? reactions;
  List<Map<String, dynamic>>? templates;
  List<bool>? actionTypes;
  List<bool>? reactionTypes;
  VoidCallback callback = () => {};

  void setServices(List<Map<String, dynamic>> newServices) {
    services = newServices;
  }

  void setCallback(VoidCallback newCallback) {
    callback = newCallback;
  }

  void getCallback() {
    callback();
  }

  void setTemplates(dynamic newTemplates) {
    templates = newTemplates;
  }

  List<Map<String, dynamic>>? getTemplates() {
    return templates;
  }

  void setActions(List<Map<String, dynamic>> newActions) {
    actions = newActions;
  }

  void setReactions(List<Map<String, dynamic>> newReactions) {
    reactions = newReactions;
  }

  void setActionTypes(List<bool> newActionTypes) {
    actionTypes = newActionTypes;
  }

  List<bool> getActionTypes() {
    return actionTypes ?? [];
  }

  void setReactionTypes(List<bool> newReactionTypes) {
    reactionTypes = newReactionTypes;
  }

  List<bool> getReactionTypes() {
    return reactionTypes ?? [];
  }

  List<Map<String, dynamic>>? getServices() {
    return services;
  }

  List<Map<String, dynamic>>? getActions() {
    return actions;
  }

  List<Map<String, dynamic>>? getReactions() {
    return reactions;
  }

  Map<String, dynamic>? getServiceById(String id) {
    return services?.firstWhere((element) => element['id'] == id);
  }

  Map<String, dynamic>? getActionById(String id) {
    return actions?.firstWhere((element) => element['id'] == id);
  }

  Map<String, dynamic>? getReactionById(String id) {
    return reactions?.firstWhere((element) => element['id'] == id);
  }

  Map<String, dynamic>? getServiceByName(String name) {
    return services?.firstWhere((element) => element['name'] == name);
  }

  Map<String, dynamic>? getActionByName(String name) {
    return actions?.firstWhere((element) => element['name'] == name);
  }

  Map<String, dynamic>? getReactionByName(String name) {
    return reactions?.firstWhere((element) => element['name'] == name);
  }

  void deleteService() {
    services = null;
  }

  void deleteTemplates() {
    templates = null;
  }


  void deleteProvider() {
    services = null;
    actions = null;
    reactions = null;
    templates = null;
  }
}

class UserPreferences extends ChangeNotifier {
  ThemeData currentTheme = AppTheme.lightTheme;
  String language = "en_US";

  void toggleTheme() {
    currentTheme = (currentTheme == AppTheme.lightTheme)
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
    notifyListeners();
  }

  ThemeData getTheme() {
    return currentTheme;
  }

  String getLanguage() {
    return language;
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }
}

class AreaStatePageProvider {
  AreaStatePage page = AreaStatePage.home;
  VoidCallback callback = () => {};

  void setPage(AreaStatePage newPage) {
    page = newPage;
    callback();
  }

  AreaStatePage getPage() {
    return page;
  }

  void setCallback(VoidCallback newCallback) {
    callback = newCallback;
  }
  void getCallback() {
    callback();
  }
}

class NavbarStateProvider {
  Function(int index) onItemTapped = (i) => {};

  void setCallbackTapped(Function(int index) newCallback) {
    onItemTapped = newCallback;
  }
}

class AreaCreateProvider {
  AreaController areaController = AreaController();

  AreaCreateProvider() {
    areaController.initSwitch(true);
  }

  AreaController getController() {
    return areaController;
  }

  void setController() {
    areaController = AreaController();
  }

  void resetProvider() {
    areaController = AreaController();
    areaController.initSwitch(true);
  }
}

final authProvider = Provider<AuthProvider?>((ref) => AuthProvider());
final areaCreateProvider =
    Provider<AreaCreateProvider?>((ref) => AreaCreateProvider());
final serviceProvider = Provider<ServiceProvider?>((ref) => ServiceProvider());
final userPreferencesProvider =
    ChangeNotifierProvider<UserPreferences>((ref) => UserPreferences());
final areaStatePageProvider =
    Provider<AreaStatePageProvider>((ref) => AreaStatePageProvider());
final navbarProvider =
    Provider<NavbarStateProvider>((ref) => NavbarStateProvider());
