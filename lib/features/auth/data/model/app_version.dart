class AppVersion {
  final bool allowToLogin;
  final int currentVersion;
  final String? url;
  final String? description;

  AppVersion({
    required this.allowToLogin,
    required this.currentVersion,
    this.url,
    this.description,
  });
}
