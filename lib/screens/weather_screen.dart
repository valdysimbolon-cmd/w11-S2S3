import 'package:flutter/material.dart';
import '../service/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _service = WeatherService();
  final _controller = TextEditingController(text: 'Medan');
  String _result = 'Belum ada data';
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);          // ← PERBAIKAN
    try {
      final data = await _service.fetchWeather(_controller.text);
      final temp = data['main']['temp'];
      final desc = data['weather'][0]['description'];
      setState(() => _result = '$temp °C, $desc');   // ← PERBAIKAN
    } catch (e) {
      setState(() => _result = e.toString());        // ← PERBAIKAN
    } finally {
      setState(() => _loading = false);              // ← PERBAIKAN
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuaca (Third Party API)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Kota'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _loading ? null : _load,
            child: const Text('Cari'),
          ),
          const SizedBox(height: 24),
          _loading
              ? const CircularProgressIndicator()
              : Text(_result),
        ]),
      ),
    );
  }
}