enum DepartmentsEnum {
  publicRelation('روابط عمومی'),
  admin('ارتباط مستقیم با مدیریت');

  const DepartmentsEnum(this.value);

  final String value;
}

final List<DepartmentsEnum> departments = [
  DepartmentsEnum.publicRelation,
  DepartmentsEnum.admin,
];
