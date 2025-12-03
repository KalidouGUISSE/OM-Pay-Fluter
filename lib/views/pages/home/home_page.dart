import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/home_drawer.dart';
import 'widgets/header_widget.dart';
import 'widgets/transaction_form_widget.dart';
import 'widgets/other_operations_widget.dart';
import 'widgets/history_section_widget.dart';
import 'package:flutter_application_1/theme/auth_provider.dart';
import 'package:flutter_application_1/theme/transaction_provider.dart';
import 'package:flutter_application_1/theme/language_provider.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/core/utils/transaction_types.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOperation = 'payer'; // 'payer' ou 'transferer'

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

        // Récupérer les données utilisateur si nécessaire
        if (authProvider.isAuthenticated && authProvider.userData == null) {
          await authProvider.fetchUserData();
        }

        // Récupérer automatiquement le solde après authentification si pas déjà chargé
        if (authProvider.isAuthenticated && authProvider.userData != null && transactionProvider.balance == null && !transactionProvider.isLoadingBalance) {
          final success = await transactionProvider.fetchBalance();
          if (!success && mounted) {
            // Gestion d'erreur silencieuse - le solde sera récupéré manuellement par l'utilisateur
            // On peut logger l'erreur ou afficher un message subtil
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.read<LanguageProvider>().getText('solde_impossible')),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.orange,
              ),
            );
          }
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
        SnackBar(
          content: Text(context.read<LanguageProvider>().getText('saisir_destinataire')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<LanguageProvider>().getText('saisir_montant')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation du montant
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<LanguageProvider>().getText('montant_invalide')),
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
          SnackBar(
            content: Text(context.read<LanguageProvider>().getText('telephone_invalide')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (selectedOperation == 'payer') {
      // Paiement marchand - validation code marchand
      if (!Validator.isValidMerchantCode(recipient)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<LanguageProvider>().getText('code_marchand_invalide')),
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
            content: Text('${context.read<LanguageProvider>().getText('transaction_reussie')} ${transaction?.reference ?? "N/A"}'),
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
            content: Text('${context.read<LanguageProvider>().getText('erreur_transaction')} $e'),
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
      body: Column(
        children: [
            // HEADER - Bonjour et QR Code
            const HeaderWidget(),

            const SizedBox(height: 8),

            // CARD Payer / Transférer avec Scanner
            TransactionFormWidget(
              selectedOperation: selectedOperation,
              recipientController: _recipientController,
              amountController: _amountController,
              isCreatingTransaction: _isCreatingTransaction,
              onOperationChanged: (operation) {
                setState(() {
                  selectedOperation = operation;
                  _recipientController.clear();
                  _amountController.clear();
                });
              },
              onCreateTransaction: _createTransaction,
            ),

            const SizedBox(height: 12),

            // Pour toute autre opération - Texte and Max it Button
            const OtherOperationsWidget(),

            const SizedBox(height: 12),

            // Historique section - takes remaining space
            const Expanded(
              child: HistorySectionWidget(),
            ),
        ],
      ),
    );
  }
}
