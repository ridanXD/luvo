import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusPesananPage extends StatefulWidget {
  const StatusPesananPage({super.key});

  @override
  State<StatusPesananPage> createState() => _StatusPesananPageState();
}

class _StatusPesananPageState extends State<StatusPesananPage> {
  int currentStep = 3;

  final status = [
    'Menunggu Konfirmasi',
    'Diterima',
    'Dijemput',
    'Sedang Dikerjakan',
    'Siap Diantar',
    'Selesai',
  ];

  final waktu = [
    'Sen, 2 Nov · 08.45',
    'Sen, 2 Nov · 08.52',
    'Sen, 2 Nov · 09.30',
    'Sen, 2 Nov · 11.10',
    'Sel, 3 Nov · 15.30',
    'Sel, 3 Nov · 16.00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putih,
      appBar: AppBar(
        title: const Text(
          'Status Pesanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.putih,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ilham Laundry',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Status: ${status[currentStep]}',
            style: const TextStyle(color: AppColors.secondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Terakhir diperbarui: ${waktu[currentStep]}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.teksAbu,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(status.length, (i) {
                final selesai = i <= currentStep;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          i < currentStep
                              ? Icons.check_circle
                              : i == currentStep
                                  ? Icons.radio_button_checked
                                  : Icons.circle_outlined,
                          color: selesai
                              ? AppColors.secondary
                              : AppColors.teksAbu,
                        ),
                        if (i < status.length - 1)
                          Container(
                            width: 2,
                            height: 28,
                            color: i < currentStep
                                ? AppColors.secondary
                                : Colors.white,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status[i],
                              style: TextStyle(
                                fontWeight: i == currentStep
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: i == currentStep
                                    ? AppColors.secondary
                                    : AppColors.teks,
                              ),
                            ),
                            if (selesai)
                              Text(
                                waktu[i],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
