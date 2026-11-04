import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key});
  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  int currentStep = 3;
  bool isMitra = true;

  final status = [
    'Menunggu Konfirmasi', 'Diterima', 'Dijemput',
    'Sedang Dikerjakan', 'Siap Diantar', 'Selesai',
  ];

  final waktu = [
    'Sen, 2 Nov · 08.45', 'Sen, 2 Nov · 08.52',
    'Sen, 2 Nov · 09.30', 'Sen, 2 Nov · 11.10',
    'Sel, 3 Nov · 15.30', 'Sel, 3 Nov · 16.00',
  ];

  void _maju() => setState(() => currentStep++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        centerTitle: true,
        backgroundColor: AppColors.putih,
        surfaceTintColor: AppColors.putih,
        elevation: 0,
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Pesanan LV-001', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text('Status: ${status[currentStep]}',
            style: const TextStyle(color: AppColors.secondary)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.putih,
              borderRadius: BorderRadius.circular(16)),
          child: Column(children: List.generate(status.length, (i) {
            final selesai = i <= currentStep;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Icon(currentStep == status.length - 1 || i < currentStep
                    ? Icons.check_circle : i == currentStep
                    ? Icons.radio_button_checked : Icons.circle_outlined,
                  color: selesai ? AppColors.secondary : AppColors.teksAbu),
                if (i < status.length - 1)
                  Container(width: 2, height: 28,
                    color: currentStep == status.length - 1 || i < currentStep
                        ? AppColors.secondary : AppColors.primary),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(status[i], style: TextStyle(
                    fontWeight: i == currentStep ? FontWeight.bold : FontWeight.normal,
                    color: i == currentStep ? AppColors.secondary : AppColors.teks)),
                  if (selesai) Text(waktu[i],
                    style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                ]),
              )),
            ]);
          })),
        ),
        const SizedBox(height: 20),
        if (isMitra)
          currentStep == status.length - 1
              ? const Center(child: Text('Pesanan selesai'))
              : FilledButton(
                  onPressed: _maju,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.putih,
                  ),
                  child: Text(status[currentStep + 1]),
                ),
      ]),
    );
  }
}
