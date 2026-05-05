// // ignore_for_file: avoid_dynamic_calls
//
// import 'package:dio/dio.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';
// import 'package:service_provider/core/error/error.dart';
// import 'package:service_provider/core/error/failure.dart';
// import 'package:service_provider/core/injections/injection.dart';
// import 'package:service_provider/core/logger/app_logger.dart';
// import 'package:service_provider/features/authentication/data/repository/repository.dart';
//

// best used for dio related setup

// class EitherSafeRunner {
//
//   Future<Either<Failure, T>> call<T>({
//     required Future<T> Function() safeCallback,
//   }) async {
//     try {
//       return Right(await safeCallback());
//     } catch (e, stackTrace) {
//       if (kDebugMode) {
//         Logger().e('EitherSafeRunner', error: e, stackTrace: stackTrace);
//       }
//       if (e is DioException) {
//         if (kDebugMode) {
//           AppLogger.e(e.response);
//         }
//         if (e.type == DioExceptionType.connectionTimeout ||
//             e.type == DioExceptionType.receiveTimeout ||
//             e.type == DioExceptionType.sendTimeout ||
//             e.type == DioExceptionType.connectionError) {
//           return const Left(
//             Failure.serverError(
//               message: 'Your connection has timed out, please try again!!',
//             ),
//           );
//         } else if (e.response!.statusCode == 401 && e.response!.data['message'] == 'Invalid access Token') {
//           final refresh = await sl<AuthRepository>().refreshToken();
//           return refresh.fold(
//             (l) {
//               return Left(
//                 Failure.serverError(
//                   message: ConvertFailureToString()(l),
//                 ),
//               );
//             },
//             (r) async {
//               return Right(await safeCallback());
//             },
//           );
//         } else if (e.response!.data != null && e.response!.data != '') {
//           return Left(
//             Failure.serverError(
//               message: e.response!.data['message'] as String,
//             ),
//           );
//         } else {
//           return const Left(
//             Failure.serverError(
//               message: 'Service unavailable, please try again!',
//             ),
//           );
//         }
//       }
//       if (e is AcireException) {
//         return Left(
//           e.map(
//             server: (exception) => Failure.serverError(
//               message: exception.message,
//             ),
//             noInternet: (exception) => const Failure.noInternet(),
//             unknown: (exception) => const Failure.unknown(),
//             app: (exception) => const Failure.app(),
//           ),
//         );
//       }
//       return const Left(
//         Failure.unknown(),
//       );
//     }
//   }
// }
