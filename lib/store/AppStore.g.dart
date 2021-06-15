// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on AppStoreBase, Store {
  final _$selectedLanguageAtom = Atom(name: 'AppStoreBase.selectedLanguage');

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: 'AppStoreBase.userProfileImage');

  @override
  String? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userFirstNameAtom = Atom(name: 'AppStoreBase.userFirstName');

  @override
  String? get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String? value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  final _$userLastNameAtom = Atom(name: 'AppStoreBase.userLastName');

  @override
  String? get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String? value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'AppStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$isMiniPlayerAtom = Atom(name: 'AppStoreBase.isMiniPlayer');

  @override
  bool get isMiniPlayer {
    _$isMiniPlayerAtom.reportRead();
    return super.isMiniPlayer;
  }

  @override
  set isMiniPlayer(bool value) {
    _$isMiniPlayerAtom.reportWrite(value, super.isMiniPlayer, () {
      super.isMiniPlayer = value;
    });
  }

  final _$AppStoreBaseActionController = ActionController(name: 'AppStoreBase');

  @override
  void setMiniPlayer(bool value) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setMiniPlayer');
    try {
      return super.setMiniPlayer(value);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String aLanguage) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLanguage');
    try {
      return super.setLanguage(aLanguage);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserProfile(String? image) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setUserProfile');
    try {
      return super.setUserProfile(image);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFirstName(String? name) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setFirstName');
    try {
      return super.setFirstName(name);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastName(String? name) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLastName');
    try {
      return super.setLastName(name);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool aIsLoading) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setLoading');
    try {
      return super.setLoading(aIsLoading);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedLanguage: ${selectedLanguage},
userProfileImage: ${userProfileImage},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
isLoading: ${isLoading},
isMiniPlayer: ${isMiniPlayer}
    ''';
  }
}
