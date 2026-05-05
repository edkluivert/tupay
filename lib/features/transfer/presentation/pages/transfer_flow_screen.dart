import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/pages/amount_view.dart';
import 'package:tupay/features/transfer/presentation/pages/reciepients_view.dart';
import 'package:tupay/features/transfer/presentation/pages/review_view.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_cubit.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/contacts_sheet.dart';
import 'package:tupay/features/transfer/presentation/widgets/transfer_app_bar.dart';
import 'package:tupay/features/transfer/presentation/widgets/transfer_stepper.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

class TransferFlowScreen extends StatelessWidget {
  const TransferFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransferFlowCubit(),
      child: const _TransferFlowView(),
    );
  }
}

// ─── Root view ────────────────────────────────────────────────────────────────

class _TransferFlowView extends StatefulWidget {
  const _TransferFlowView();

  @override
  State<_TransferFlowView> createState() => _TransferFlowViewState();
}

class _TransferFlowViewState extends State<_TransferFlowView> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  final _amountController = TextEditingController(text: '1000');
  final _recipientNameController = TextEditingController();
  final _recipientAccountController = TextEditingController();

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferFlowCubit, TransferFlowState>(
      listener: (context, state) {
        if (state.isFailure) {
          AppSnackBar.showFailure(
            context,
            message: state.message ?? 'Unable to continue.',
          );
        }
        if (state.isSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.message ?? 'Transfer submitted.',
          );
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
                      onStepTap: (s) {
                        cubit.stepChanged(s);
                        _animateToStep(cubit.state.step);
                      },
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.18, end: 0, duration: 360.ms, curve: Curves.easeOutCubic),
                  ),

                  const SizedBox(height: 20),


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









