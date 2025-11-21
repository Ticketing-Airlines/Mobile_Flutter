import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/home.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _method; // 'cash' | 'maya' | 'card'
  final _cardName = TextEditingController();
  final _cardNumber = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCvv = TextEditingController();

  @override
  void dispose() {
    _cardName.dispose();
    _cardNumber.dispose();
    _cardExpiry.dispose();
    _cardCvv.dispose();
    super.dispose();
  }

  bool get _isCardValid {
    return _cardName.text.trim().isNotEmpty &&
        _cardNumber.text.trim().length >= 12 &&
        _cardExpiry.text.trim().isNotEmpty &&
        _cardCvv.text.trim().length >= 3;
  }

  @override
  Widget build(BuildContext context) {
    // optional total passed via Navigator (RouteSettings.arguments: {'total': double})
    final args = ModalRoute.of(context)?.settings.arguments;
    final double? total = (args is Map && args['total'] is num)
        ? (args['total'] as num).toDouble()
        : null;
    final totalLabel = total != null ? "PHP ${total.toStringAsFixed(2)}" : "--";

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF111827), Color(0xFF1E3A8A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Total summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        totalLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Choose Payment Method",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Cash
                RadioListTile<String>(
                  value: 'cash',
                  groupValue: _method,
                  title: const Text(
                    "Cash",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    "Pay at counter or on arrival",
                    style: TextStyle(color: Colors.white54),
                  ),
                  activeColor: Colors.blueAccent,
                  onChanged: (v) => setState(() => _method = v),
                ),

                // Maya
                RadioListTile<String>(
                  value: 'maya',
                  groupValue: _method,
                  title: const Text(
                    "Maya",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    "Pay via Maya QR or wallet",
                    style: TextStyle(color: Colors.white54),
                  ),
                  activeColor: Colors.blueAccent,
                  onChanged: (v) => setState(() => _method = v),
                ),

                // Debit/Credit Card
                RadioListTile<String>(
                  value: 'card',
                  groupValue: _method,
                  title: const Text(
                    "Debit / Credit Card",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    "Pay with card",
                    style: TextStyle(color: Colors.white54),
                  ),
                  activeColor: Colors.blueAccent,
                  onChanged: (v) => setState(() => _method = v),
                ),

                // Card fields (only when card selected)
                if (_method == 'card') ...[
                  const SizedBox(height: 8),
                  _buildField(controller: _cardName, hint: "Cardholder Name"),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _cardNumber,
                    hint: "Card Number",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _cardExpiry,
                          hint: "MM/YY",
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: _buildField(
                          controller: _cardCvv,
                          hint: "CVV",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        (_method == null ||
                            (_method == 'card' && !_isCardValid))
                        ? null
                        : () {
                            // Simulate payment processing...
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Payment successful"),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          },
                    child: Text(
                      _method == null
                          ? "Select payment method"
                          : (_method == 'card' ? "Pay with Card" : "Proceed"),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
