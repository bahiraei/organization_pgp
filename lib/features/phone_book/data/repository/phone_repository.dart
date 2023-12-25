import '../../../../core/client/http_client.dart';
import '../model/phone_book_model.dart';
import '../source/phone_data_source.dart';

abstract class IPhoneRepository {
  Future<PhoneBookModel> getAll();
}

class PhoneRepository implements IPhoneRepository {
  final IPhoneDataSource dataSource;

  PhoneRepository({
    required this.dataSource,
  });

  @override
  Future<PhoneBookModel> getAll() {
    return dataSource.getAll();
  }
}

final phoneRepository = PhoneRepository(
  dataSource: PhoneDataSource(
    dio: httpClient,
  ),
);
