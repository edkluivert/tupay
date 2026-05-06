import 'package:flutter_animate/flutter_animate.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/data/models/transfer_currency.dart';
import 'package:tupay/features/transfer/presentation/pages/amount_view.dart';
import 'package:tupay/features/transfer/presentation/pages/reciepients_view.dart';
import 'package:tupay/features/transfer/presentation/pages/review_view.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_cubit.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/contacts_sheet.dart';
import 'package:tupay/features/transfer/presentation/widgets/transfer_app_bar.dart';
import 'package:tupay/features/transfer/presentation/widgets/transfer_stepper.dart';

class TransferFlowScreen extends StatelessWidget {
  const TransferFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransferFlowCubit()..loadSavedDraft(),
      child: const _TransferFlowView(),
    );
  }
}

class _TransferFlowView extends StatefulWidget {
  const _TransferFlowView();

  @override
  State<_TransferFlowView> createState() => _TransferFlowViewState();
}

class _TransferFlowViewState extends State<_TransferFlowView>
    with RestorationMixin {
  final _formKey = GlobalKey<FormState>();

  late final PageController _pageController;

  final _stepIndex = RestorableInt(0);
  final _sendAmount = RestorableString('');
  final _recipientName = RestorableString('');
  final _recipientAccount = RestorableString('');
  final _recipientCurrency = RestorableString(TransferCurrency.rmb.name);

  late final TextEditingController _amountController;
  late final TextEditingController _recipientNameController;
  late final TextEditingController _recipientAccountController;

  @override
  String get restorationId => 'transfer_flow_view';

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    _amountController = TextEditingController();
    _recipientNameController = TextEditingController();
    _recipientAccountController = TextEditingController();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_stepIndex, 'step_index');
    registerForRestoration(_sendAmount, 'send_amount');
    registerForRestoration(_recipientName, 'recipient_name');
    registerForRestoration(_recipientAccount, 'recipient_account');
    registerForRestoration(_recipientCurrency, 'recipient_currency');

    final safeStepIndex = _stepIndex.value
        .clamp(
      0,
      TransferStep.values.length - 1,
    )
        ;

    final restoredStep = TransferStep.values[safeStepIndex];

    final restoredCurrency = TransferCurrency.values.firstWhere(
          (currency) => currency.name == _recipientCurrency.value,
      orElse: () => TransferCurrency.rmb,
    );

    _amountController.text = _sendAmount.value;
    _recipientNameController.text = _recipientName.value;
    _recipientAccountController.text = _recipientAccount.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cubit = context.read<TransferFlowCubit>()

      ..restoreFlow(
        step: restoredStep,
        sendAmount: _sendAmount.value,
        recipientName: _recipientName.value,
        recipientAccount: _recipientAccount.value,
        recipientCurrency: restoredCurrency,
      );

      if (_pageController.hasClients) {
        _pageController.jumpToPage(restoredStep.index);
      }
    });
  }

  @override
  void dispose() {
    _stepIndex.dispose();
    _sendAmount.dispose();
    _recipientName.dispose();
    _recipientAccount.dispose();
    _recipientCurrency.dispose();

    _pageController.dispose();

    _amountController.dispose();
    _recipientNameController.dispose();
    _recipientAccountController.dispose();

    super.dispose();
  }

  void _animateToStep(TransferStep step) {
    _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleNext(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final cubit = context.read<TransferFlowCubit>();
    final advanced = cubit.nextStep();

    if (advanced) {
      _animateToStep(cubit.state.step);
    }
  }

  void _handleBack(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final cubit = context.read<TransferFlowCubit>();

    if (cubit.state.isFirstStep) {
      Navigator.of(context).maybePop();
      return;
    }

    cubit.previousStep();
    _animateToStep(cubit.state.step);
  }

  void _handleReviewAndSend(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<TransferFlowCubit>().reviewAndSend();
  }

  void _showContactsSheet(BuildContext context) {
    showModalBottomSheet<MockContact>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ContactsSheet(
        onSelected: (contact) {
          context.read<TransferFlowCubit>().selectContact(contact);

          _recipientNameController.text = contact.name;
          _recipientAccountController.text = contact.account;

          Navigator.pop(context);
        },
      ),
    );
  }

  void _syncControllersFromState(TransferFlowState state) {
    if (_amountController.text != state.sendAmount) {
      _amountController.text = state.sendAmount;
    }

    if (_recipientNameController.text != state.recipientName) {
      _recipientNameController.text = state.recipientName;
    }

    if (_recipientAccountController.text != state.recipientAccount) {
      _recipientAccountController.text = state.recipientAccount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferFlowCubit, TransferFlowState>(
      listener: (context, state) {
        _stepIndex.value = state.step.index;
        _sendAmount.value = state.sendAmount;
        _recipientName.value = state.recipientName;
        _recipientAccount.value = state.recipientAccount;
        _recipientCurrency.value = state.recipientCurrency.name;

        _syncControllersFromState(state);

        if (_pageController.hasClients &&
            _pageController.page?.round() != state.step.index) {
          _pageController.jumpToPage(state.step.index);
        }

        if (state.isFailure && state.message != null) {
          AppSnackBar.showFailure(
            context,
            message: state.message ?? 'Unable to continue.',
          );
        }

        if (state.isSuccess && state.message != null) {
          AppSnackBar.showSuccess(
            context,
            message: state.message ?? 'Transfer submitted.',
          );

          _amountController.text = state.sendAmount;
          _recipientNameController.clear();
          _recipientAccountController.clear();

          _stepIndex.value = TransferStep.amount.index;
          _sendAmount.value = state.sendAmount;
          _recipientName.value = '';
          _recipientAccount.value = '';
          _recipientCurrency.value = TransferCurrency.rmb.name;

          if (_pageController.hasClients) {
            _pageController.jumpToPage(TransferStep.amount.index);
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<TransferFlowCubit>();

        return PopScope(
          canPop: state.isFirstStep,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _handleBack(context);
          },
          child: Scaffold(
            appBar: TransferAppBar(
              onBack: () => _handleBack(context),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pagePadding,
                      20,
                      AppSpacing.pagePadding,
                      0,
                    ),
                    child: TransferStepper(
                      currentStep: state.step,
                      onStepTap: (step) {
                        cubit.stepChanged(step);
                        _animateToStep(cubit.state.step);
                      },
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(
                      begin: 0.18,
                      end: 0,
                      duration: 360.ms,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  context.uiHelper.verticalSpace(20),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          AmountView(
                            state: state,
                            amountController: _amountController,
                            onAmountChanged: cubit.sendAmountChanged,
                            amountValidator: cubit.validateAmount,
                            onPaymentMethodTap: cubit.paymentMethodChanged,
                            onNext: () => _handleNext(context),
                          ),
                          RecipientView(
                            state: state,
                            nameController: _recipientNameController,
                            accountController: _recipientAccountController,
                            onNameChanged: cubit.recipientNameChanged,
                            onAccountChanged: cubit.recipientAccountChanged,
                            nameValidator: cubit.validateRecipientName,
                            accountValidator: cubit.validateRecipientAccount,
                            onSelectContact: () => _showContactsSheet(context),
                            onNext: () => _handleNext(context),
                            onBack: () => _handleBack(context),
                          ),
                          ReviewView(
                            state: state,
                            onReviewAndSend: () => _handleReviewAndSend(context),
                            onBack: () => _handleBack(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}