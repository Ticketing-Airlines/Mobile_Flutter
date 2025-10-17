class Flight {
  final String from;
  final String to;
  final String airline;
  final String date;
  final String time;
  final double price;

  Flight({
    required this.from,
    required this.to,
    required this.airline,
    required this.date,
    required this.time,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      from: json['from'],
      to: json['to'],
      airline: json['airline'],
      date: json['date'],
      time: json['time'],
      price: json['price'],
    );
  }
}
