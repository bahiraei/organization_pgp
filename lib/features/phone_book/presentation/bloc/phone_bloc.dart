import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/exception/app_exception.dart';
import '../../../../core/utils/routes.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/phone_book_model.dart';
import '../../data/repository/phone_repository.dart';

part 'phone_event.dart';
part 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState> {
  final IPhoneRepository phoneRepository;
  final BuildContext context;

  final String localKey = "offline_phones";

  PhoneBloc({
    required this.phoneRepository,
    required this.context,
  }) : super(PhoneInitial()) {
    on<PhoneEvent>((event, emit) async {
      if (event is PhoneStarted) {
        try {
          emit(PhoneLoading());
          List<Phone> phones = [];
          if (event.isRefreshing) {
            phones = await getPhones();
          } else {
            final local = await getLocalPhones();
            if (local.isEmpty) {
              phones = await getPhones();
            } else {
              phones = local;
            }
          }
          if (phones.isEmpty) {
            emit(PhoneEmpty());
          } else {
            var searched = phones;
            if (event.searchTag != null) {
              searched = phones.where(
                (item) {
                  bool find = false;
                  find =
                      item.unitTitle?.contains(event.searchTag ?? '') ?? false;
                  if (find) return find;

                  find =
                      item.personName?.contains(event.searchTag ?? '') ?? false;
                  if (find) return find;

                  find = item.bohkt?.contains(event.searchTag ?? '') ?? false;
                  if (find) return find;

                  find =
                      item.unitTitle?.contains(event.searchTag ?? '') ?? false;
                  if (find) return find;

                  find = item.centerOutput?.contains(event.searchTag ?? '') ??
                      false;
                  if (find) return find;

                  find = item.description?.contains(event.searchTag ?? '') ??
                      false;
                  if (find) return find;

                  find = item.phone?.contains(event.searchTag ?? '') ?? false;
                  if (find) return find;

                  return find;
                },
              ).toList();
            }
            emit(
              PhoneSuccess(
                phones: searched,
              ),
            );
          }
        } catch (e) {
          final exception = await ExceptionHandler.handleDioError(e);
          if (exception is UnauthorizedException) {
            await authRepository.signOut().then((value) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.splash,
                (route) => false,
              );
            });
          } else {
            emit(PhoneError(exception: exception));
          }
        }
      }
    });
  }

  Future<List<Phone>> getPhones() async {
    final phones = await phoneRepository.getAll();
    await savePhonesToLocal(phones.phones);
    return phones.phones;
  }

  Future<List<Phone>> getLocalPhones() async {
    final shared = await SharedPreferences.getInstance();

    final localData = shared.getString(localKey);

    List<Phone> phones = [];

    phones = localData != null
        ? List.from(jsonDecode(localData))
            .map(
              (item) => Phone.fromJson(item),
            )
            .toList()
        : [];

    return phones;
  }

  Future<bool> savePhonesToLocal(List<Phone> phones) async {
    final shared = await SharedPreferences.getInstance();

    return await shared.setString(
      localKey,
      jsonEncode(phones),
    );
  }
}
