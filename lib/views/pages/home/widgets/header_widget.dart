import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/auth_provider.dart';
import '../../../../theme/transaction_provider.dart';
import '../../../../core/utils/image_cache.dart' as qr_cache;

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF333333) : Colors.black87;

    return Builder(
      builder: (context) {
        final authProvider = Provider.of<AuthProvider>(context);
        final transactionProvider = Provider.of<TransactionProvider>(context);
        final userName = authProvider.userData?.user.nom ?? 'Utilisateur';
        final codeQr = authProvider.userData?.compte.codeQr;

        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: headerBg,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bonjour et nom utilisateur sur la même ligne
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Bonjour ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: userName,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (!isBalanceVisible)
                              const Text(
                                "★★★★★★★★ ",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (isBalanceVisible && transactionProvider.balance != null)
                              Text(
                                "${transactionProvider.balance!.toStringAsFixed(0)} ",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (isBalanceVisible && transactionProvider.balance == null && !transactionProvider.isLoadingBalance)
                              const Text(
                                "0 ",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (transactionProvider.isLoadingBalance)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                ),
                              ),
                            const Text(
                              "FCFA ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Toujours récupérer le solde à chaque clic
                                final success = await transactionProvider.fetchBalance();
                                if (success) {
                                  setState(() {
                                    isBalanceVisible = !isBalanceVisible;
                                  });
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erreur: ${transactionProvider.balanceError ?? "Impossible de récupérer le solde"}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    transactionProvider.clearBalanceError();
                                  }
                                }
                              },
                              child: Icon(
                                isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 102,
                    height: 102,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3)),
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: codeQr != null && codeQr.isNotEmpty
                              ? FutureBuilder<ui.Image?>(
                                  future: qr_cache.QrImageCache.getQrImage(codeQr),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data != null) {
                                      return RawImage(
                                        image: snapshot.data,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                    return Icon(Icons.qr_code_2, color: Colors.black, size: 70);
                                  },
                                )
                              : Icon(Icons.qr_code_2, color: Colors.black, size: 70),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}