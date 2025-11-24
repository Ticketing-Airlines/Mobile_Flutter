import 'package:flutter/material.dart';
import 'package:ticketing_flutter/services/flight.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Flight? flight;

  // Guests and per-guest details (name, dob, passengerType, contact)
  final List<Map<String, dynamic>>? guests;

  // Seat assignments per guest index
  final List<String>? seatAssignments;

  // Selected fare / class / promo
  final String? travelClass;
  final double? selectedPrice;
  final String? promoCode;
  final double? promoDiscount; // absolute value

  // Bundle / add-ons selected (example: { "name": "Extra Baggage", "price": 120.0 })
  final List<Map<String, dynamic>>? addOns;
  final Map<String, dynamic>? bundle;

  // Contact & billing
  final Map<String, dynamic>? contact; // { "email": "...", "phone": "..." }
  final Map<String, dynamic>?
  billing; // { "method": "Card", "cardLast4": "1234" }

  // Payment & booking result
  final String? paymentMethod;
  final bool? paymentSuccessful;
  final String? bookingReference;
  final DateTime? bookingTime;
  final List<Map<String, dynamic>>?
  issuedTickets; // [{ "passengerIndex":0, "ticketNo":"ABC123", "pnr":"PNR1" }]

  // Timeline of user actions from selection -> payment -> confirm (optional)
  final List<String>? actionTimeline;

  // Total override (optional)
  final double? total;

  const BookingConfirmationPage({
    Key? key,
    this.flight,
    this.guests,
    this.seatAssignments,
    this.travelClass,
    this.selectedPrice,
    this.promoCode,
    this.promoDiscount,
    this.addOns,
    this.bundle,
    this.contact,
    this.billing,
    this.paymentMethod,
    this.paymentSuccessful,
    this.bookingReference,
    this.bookingTime,
    this.issuedTickets,
    this.actionTimeline,
    this.total,
  }) : super(key: key);

  String currency(double? v) => v == null ? '-' : "₱${v.toStringAsFixed(2)}";

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A8A),
      ),
    ),
  );

  Widget _infoRow(String label, String value, {bool emphasize = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _guests = guests ?? [];
    final _seatAssignments =
        seatAssignments ?? List.generate(_guests.length, (index) => "-");
    final double flightPrice = selectedPrice ?? flight?.price ?? 0.0;
    final double bundlePrice = (bundle?["price"] ?? 0).toDouble();
    final double addOnsTotal = (addOns ?? []).fold(
      0.0,
      (s, a) => s + ((a["price"] ?? 0).toDouble()),
    );
    final int pax = _guests.length;
    final double subtotal =
        (flightPrice * pax) + (bundlePrice * pax) + addOnsTotal;
    final double discount = promoDiscount ?? 0.0;
    final double computedTotal = total ?? (subtotal - discount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Confirmation"),
        backgroundColor: const Color(0xFF1E3A8A),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + booking status
                Center(
                  child: Column(
                    children: [
                      Icon(
                        paymentSuccessful == true
                            ? Icons.check_circle
                            : Icons.info,
                        color: paymentSuccessful == true
                            ? Colors.green
                            : Colors.orange,
                        size: 64,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        paymentSuccessful == true
                            ? "Booking Confirmed"
                            : "Booking Pending",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Ref: ${bookingReference ?? DateTime.now().millisecondsSinceEpoch}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Booked: ${_formatDateTime(bookingTime ?? DateTime.now())}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Action timeline (what user clicked)
                if ((actionTimeline ?? []).isNotEmpty) ...[
                  _sectionTitle("Your Actions"),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actionTimeline!.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      return ListTile(
                        leading: CircleAvatar(child: Text("${i + 1}")),
                        title: Text(actionTimeline![i]),
                        dense: true,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],

                // Flight summary
                _sectionTitle("Flight Summary"),
                _infoRow("From", flight?.from ?? "-"),
                _infoRow("To", flight?.to ?? "-"),
                _infoRow("Airline", flight?.airline ?? "-"),
                _infoRow("Flight No.", flight?.flightNumber ?? "-"),
                _infoRow("Date", flight?.date ?? "-"),
                _infoRow("Time", flight?.time ?? "-"),
                _infoRow("Class", travelClass ?? "-"),
                _infoRow("Fare / pax", currency(flightPrice)),

                const SizedBox(height: 12),

                // Passengers, seats, contact
                _sectionTitle("Passengers & Seats"),
                ...List.generate(_guests.length, (i) {
                  final g = _guests[i];
                  final seat = _seatAssignments.length > i
                      ? _seatAssignments[i]
                      : "-";
                  final name =
                      "${g['title'] ?? ''} ${g['firstName'] ?? ''} ${g['lastName'] ?? ''}"
                          .trim();
                  final ptype = g['passengerType'] ?? "";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Passenger ${i + 1}", name.isEmpty ? "-" : name),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          top: 2,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Type",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              ptype.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Seat",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              seat,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 12),

                // Add-ons & extras
                if ((addOns ?? []).isNotEmpty) ...[
                  _sectionTitle("Add-ons / Extras"),
                  ...addOns!
                      .map(
                        (a) => _infoRow(
                          a["name"] ?? "-",
                          currency((a["price"] ?? 0).toDouble()),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 8),
                ],

                // Bundle
                if (bundle != null) ...[
                  _sectionTitle("Bundle"),
                  _infoRow("Bundle Name", bundle?["name"] ?? "-"),
                  _infoRow("Bundle Price / pax", currency(bundlePrice)),
                ],

                const SizedBox(height: 12),

                // Fare breakdown
                _sectionTitle("Fare Summary"),
                _infoRow("Fare / pax", currency(flightPrice)),
                _infoRow("Passengers", pax.toString()),
                if (bundlePrice > 0)
                  _infoRow("Bundle Total", currency(bundlePrice * pax)),
                if (addOnsTotal > 0)
                  _infoRow("Add-ons Total", currency(addOnsTotal)),
                if ((promoCode ?? "").isNotEmpty)
                  _infoRow("Promo ($promoCode)", "-${currency(discount)}"),
                const Divider(),
                _infoRow("SUBTOTAL", currency(subtotal), emphasize: true),
                _infoRow("TOTAL", currency(computedTotal), emphasize: true),

                const SizedBox(height: 12),

                // Payment & contact
                _sectionTitle("Payment & Contact"),
                _infoRow(
                  "Payment Method",
                  paymentMethod ?? billing?['method'] ?? "-",
                ),
                if (billing?['cardLast4'] != null)
                  _infoRow("Card", "**** ${billing!['cardLast4']}"),
                _infoRow(
                  "Payment Status",
                  paymentSuccessful == true
                      ? "Successful"
                      : (paymentSuccessful == false ? "Failed" : "Pending"),
                ),
                if (contact != null) ...[
                  _infoRow("Contact Email", contact?['email'] ?? "-"),
                  _infoRow("Contact Phone", contact?['phone'] ?? "-"),
                ],

                const SizedBox(height: 12),

                // Issued tickets / PNRs
                if ((issuedTickets ?? []).isNotEmpty) ...[
                  _sectionTitle("Issued Tickets"),
                  ...issuedTickets!.map((t) {
                    final idx = t["passengerIndex"] ?? 0;
                    final name = idx < _guests.length
                        ? "${_guests[idx]['firstName'] ?? ''} ${_guests[idx]['lastName'] ?? ''}"
                              .trim()
                        : "Passenger ${idx + 1}";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Passenger", name),
                        _infoRow("Ticket No.", t["ticketNo"] ?? "-"),
                        _infoRow("PNR", t["pnr"] ?? "-"),
                        const SizedBox(height: 6),
                      ],
                    );
                  }).toList(),
                ],

                const SizedBox(height: 18),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Download Receipt"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Download not implemented.'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share not implemented.'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        child: const Text("View Itinerary"),
                        onPressed: () {
                          // navigate to itinerary or pop with result; placeholder:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Itinerary view not implemented.'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        child: const Text("Done"),
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
