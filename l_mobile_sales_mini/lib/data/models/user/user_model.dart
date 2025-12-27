import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake,)
class User {
  final String id;
  final String username;
  final String password;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String department;
  final List<String> permissions;
  final double approvalLimit;
  final String region;
  final DateTime? lastLogin;
  final String status;
  final bool twoFactorEnabled;
  final DateTime createdDate;
  final String? profileImage;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.permissions,
    required this.approvalLimit,
    required this.region,
    this.lastLogin,
    required this.status,
    required this.twoFactorEnabled,
    required this.createdDate,
    this.profileImage,
    required this.preferences
});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName => '$firstName $lastName';
  bool get isActive => status == 'Active';
  bool get canApproveSales => permissions.contains('approve_sales');
}

@JsonSerializable()
class UserPreferences {
  final String language;
  final String theme;
  // final NotificationSettings notifications;
  @JsonKey(includeFromJson: false)
  final dynamic notifications;

  @JsonKey(defaultValue: [])
  final List<String> dashboardWidgets;

  UserPreferences({
    required this.language,
    required this.theme,
    this.notifications,
    required this.dashboardWidgets,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}