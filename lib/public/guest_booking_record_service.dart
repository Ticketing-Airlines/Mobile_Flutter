import 'dart:convert';

import 'package:ticketing_flutter/services/api_client.dart';
import 'package:ticketing_flutter/services/flight.dart';

/// Persists guest (public) booking snapshots via `GuestBookingRecords` API — no login.
class GuestBookingRecordService {
  GuestBookingRecordService() : _api = ApiClient();

  final ApiClient _api;

  static String _pickGuestEmail(List<Map<String, dynamic>> guests) {
    for (final g in guests) {
      for (final k in ['email', 'Email']) {
        final v = g[k]?.toString().trim();
        if (v != null && v.isNotEmpty && v.contains('@')) {
          return v;
        }
      }
    }
    return 'guest-not-provided@local.invalid';
  }

  static String? _leadGuestContactName(Map<String, dynamic> g) {
    final fn = (g['firstName'] ?? g['FirstName'])?.toString().trim() ?? '';
    final ln = (g['lastName'] ?? g['LastName'])?.toString().trim() ?? '';
    final combined = '$fn $ln'.trim();
    return combined.isEmpty ? null : combined;
  }

  /// Call after successful guest payment. Uses [postUnauthenticated] (no Bearer token).
  Future<bool> submitAfterPayment({
    required Flight flight,
    required Map<String, dynamic> bundle,
    required List<Map<String, dynamic>> guests,
    required List<String> seatAssignments,
    required double selectedPrice,
    required String travelClass,
    required int adults,
    required int children,
    required int infants,
    required String paymentMethod,
    required double grandTotal,
  }) async {
    if (ApiClient.useMock) return true;

    final bookingRef = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);
    final guestsCount = guests.length;
    final bundleName = bundle['name']?.toString() ?? '';

    final details = <String, dynamic>{
      'bookingRef': bookingRef,
      'from': flight.from,
      'to': flight.to,
      'flightNumber': flight.flightNumber,
      'date': flight.date,
      'time': flight.time,
      'airline': flight.airline,
      'travelClass': travelClass,
      'bundle': bundleName,
      'guestsCount': guestsCount,
      'adults': adults,
      'children': children,
      'infants': infants,
      'seatAssignments': seatAssignments,
      'selectedPrice': selectedPrice,
      'total': grandTotal,
      'paymentMethod': paymentMethod,
      'guests': guests,
      'bookedAt': DateTime.now().toIso8601String(),
    };

    final guestEmail = _pickGuestEmail(guests);
    final contactName = guests.isNotEmpty
        ? _leadGuestContactName(guests.first)
        : null;

    final body = <String, dynamic>{
      'GuestEmail': guestEmail,
      'BookingRef': bookingRef,
      'FromDisplay': flight.from,
      'ToDisplay': flight.to,
      'FlightNumber': flight.flightNumber,
      'DateDisplay': flight.date,
      'TimeDisplay': flight.time,
      'Airline': flight.airline,
      'TravelClass': travelClass,
      'BundleName': bundleName,
      'GuestsCount': guestsCount,
      'TotalAmount': grandTotal,
      'PaymentMethod': paymentMethod,
      'DetailsJson': jsonEncode(details),
    };
    if (contactName != null && contactName.isNotEmpty) {
      body['GuestContactName'] = contactName;
    }

    final res = await _api.postUnauthenticated(
      '/GuestBookingRecords',
      body: body,
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
