import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/home_drawer.dart';
import 'widgets/historique_widget.dart';
import 'widgets/scanner_page.dart';
import 'package:flutter_application_1/theme/auth_provider.dart';
import 'package:flutter_application_1/theme/transaction_provider.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/core/utils/transaction_types.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOperation = 'payer'; // 'payer' ou 'transferer'
  bool isBalanceVisible = false; // Contrôle la visibilité du solde

  // Contrôleurs pour les champs de formulaire
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // États de chargement et d'erreur
  bool _isCreatingTransaction = false;

  @override
  void initState() {
    super.initState();
    // Listener pour formater automatiquement les numéros de téléphone
    _recipientController.addListener(_formatPhoneNumber);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Assurer que les données utilisateur sont chargées quand les providers sont disponibles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isAuthenticated && authProvider.userData == null) {
          authProvider.fetchUserData();
        }
      }
    });
  }

  @override
  void dispose() {
    _recipientController.removeListener(_formatPhoneNumber);
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Formate automatiquement les numéros de téléphone sénégalais
  void _formatPhoneNumber() {
    if (selectedOperation != 'transferer') return;

    final text = _recipientController.text;
    if (text.isEmpty) return;

    // Éviter les appels récursifs
    _recipientController.removeListener(_formatPhoneNumber);

    String formatted = text;

    // Si le texte commence par un chiffre et fait 9 chiffres (format sénégalais sans +221)
    if (RegExp(r'^\d{9}$').hasMatch(text)) {
      formatted = '+221$text';
    }
    // Si le texte fait 7 chiffres (commence par 7, 8, ou 9)
    else if (RegExp(r'^[7-9]\d{6}$').hasMatch(text)) {
      formatted = '+221$text';
    }

    // Mettre à jour seulement si le formatage a changé
    if (formatted != text) {
      _recipientController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    _recipientController.addListener(_formatPhoneNumber);
  }

  /// Crée une transaction selon le type sélectionné
  Future<void> _createTransaction() async {
    final recipient = _recipientController.text.trim();
    final amountText = _amountController.text.trim();

    // Validation des champs
    if (recipient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le numéro/code destinataire'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le montant'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation du montant
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation selon le type d'opération
    if (selectedOperation == 'transferer') {
      // Transfert d'argent - validation numéro téléphone
      if (!Validator.isValidPhoneNumber(recipient)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Numéro de téléphone invalide (format: +221XXXXXXXXX)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (selectedOperation == 'payer') {
      // Paiement marchand - validation code marchand
      if (!Validator.isValidMerchantCode(recipient)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code marchand invalide'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Démarrer la création
    setState(() {
      _isCreatingTransaction = true;
    });

    try {
      final transactionProvider = context.read<TransactionProvider>();

      TransactionType transactionTypeEnum;
      String transactionType;
      String recipientField;

      if (selectedOperation == 'transferer') {
        transactionTypeEnum = TransactionType.transfertArgent;
        transactionType = transactionTypeEnum.displayName;
        recipientField = recipient; // numéro du destinataire
      } else {
        transactionTypeEnum = TransactionType.paiementMarchand;
        transactionType = transactionTypeEnum.displayName;
        recipientField = recipient; // code_marchand
      }

      final transaction = await transactionProvider.createTransaction(
        recipientField,
        amount,
        transactionType,
      );

      if (mounted) {
        // Succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction réussie! Référence: ${transaction?.reference ?? "N/A"}'),
            backgroundColor: Colors.green,
          ),
        );

        // Vider les champs
        _recipientController.clear();
        _amountController.clear();

        // Recharger les données utilisateur pour mettre à jour l'historique
        final authProvider = context.read<AuthProvider>();
        await authProvider.fetchUserData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingTransaction = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final secondaryBg = isDark ? const Color(0xFF2D2D2D) : Colors.grey[50];
    final headerBg = isDark ? const Color(0xFF333333) : Colors.black87;
    final cardText = isDark ? Colors.white : Colors.black87;
    final hintText = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: primaryBg,
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER - Bonjour et QR Code
            Builder(
              builder: (context) {
                final authProvider = Provider.of<AuthProvider>(context);
                final transactionProvider = Provider.of<TransactionProvider>(context);
                final userName = authProvider.userData?.user.nom ?? 'Utilisateur';
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
                          const SizedBox(
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
                                  child: Icon(Icons.qr_code_2, color: Colors.black, size: 70),
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
            ),

            const SizedBox(height: 16),

            // CARD Payer / Transférer avec Scanner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: primaryBg,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black45 : Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secondaryBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Radio buttons Payer / Transférer
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOperation = 'payer';
                                  _recipientController.clear();
                                  _amountController.clear();
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectedOperation == 'payer'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selectedOperation == 'payer' ? Colors.orange : Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Payer",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: cardText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOperation = 'transferer';
                                  _recipientController.clear();
                                  _amountController.clear();
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectedOperation == 'transferer'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selectedOperation == 'transferer' ? Colors.orange : Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Transférer",
                                    style: TextStyle(color: cardText, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "m",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Espacement (rayures supprimées)
                        const SizedBox(height: 8),

                        const SizedBox(height: 12),

                        // Input fields et Scanner
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _recipientController,
                                    keyboardType: selectedOperation == 'transferer'
                                        ? TextInputType.phone
                                        : TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: selectedOperation == 'transferer'
                                          ? "Numéro destinataire (77XXXXXXX)"
                                          : "Code marchand",
                                      hintStyle: TextStyle(color: hintText),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: isDark ? Colors.grey[900] : Colors.grey[50],
                                    ),
                                    style: TextStyle(color: cardText),
                                    enabled: !_isCreatingTransaction,
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Saisir le montant",
                                      hintStyle: TextStyle(color: hintText),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: isDark ? Colors.grey[900] : Colors.grey[50],
                                    ),
                                    style: TextStyle(color: cardText),
                                    enabled: !_isCreatingTransaction,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Scanner section
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ScannerPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.grey[900] : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        size: 40,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Cliquer et\nscanner",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Espacement (rayures supprimées)
                  const SizedBox(height: 8),

                  // Bouton Valider
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        onPressed: _isCreatingTransaction ? null : _createTransaction,
                        child: _isCreatingTransaction
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                "Valider",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Espacement (rayures supprimées)
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pour toute autre opération - Texte
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pour toute autre opération",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cardText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Max it Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF404040) : Colors.grey[800],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "Max it",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Accéder à Max it",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Titre Historique
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Historique",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cardText,
                    ),
                  ),
                  const Icon(Icons.refresh, color: Colors.orange, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Historique
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final transactions = authProvider.userData?.dernieresTransactions ?? [];
                return HistoriqueWidget(transactions: transactions);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
