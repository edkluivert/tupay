import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';

class ContactsSheet extends StatefulWidget {
  const ContactsSheet({
    required this.onSelected,
    super.key,
  });

  final ValueChanged<MockContact> onSelected;

  @override
  State<ContactsSheet> createState() => _ContactsSheetState();
}

class _ContactsSheetState extends State<ContactsSheet> {
  String _query = '';

  List<MockContact> get _filtered {
    if (_query.isEmpty) return TransferFlowState.contacts;
    final q = _query.toLowerCase();
    return TransferFlowState.contacts
        .where((c) =>
    c.name.toLowerCase().contains(q) ||
        c.bank.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Contacts',
                      style: context.appTextTheme.subHeading?.copyWith(
                        fontSize: 18,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select a contact to auto-fill recipient details.',
                      style: context.appTextTheme.bodySmall14Regular?.copyWith(
                        color: AppColors.textColor2,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search field
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: context.appTextTheme.bodySmall14Regular?.copyWith(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name or bank…',
                        hintStyle: context.appTextTheme.bodySmall14Regular?.copyWith(
                          color: AppColors.textColor2,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.grey200,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.secondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Contact list
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                  child: Text(
                    'No contacts found.',
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: AppColors.textColor2,
                    ),
                  ),
                )
                    : ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: AppColors.inputBorder,
                  ),
                  itemBuilder: (context, i) {
                    final contact = _filtered[i];
                    return _ContactTile(
                      contact: contact,
                      onTap: () => widget.onSelected(contact),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onTap});

  final MockContact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyClickableWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: contact.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    color: contact.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            context.uiHelper.horizontalSpace(14),

            // Name + bank
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: AppColors.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  context.uiHelper.verticalSpace(3),
                  Text(
                    contact.bank,
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: AppColors.textColor2,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Account (truncated)
            Text(
              contact.account.length > 12
                  ? '…${contact.account.substring(contact.account.length - 8)}'
                  : contact.account,
              style: context.appTextTheme.bodySmall14Regular?.copyWith(
                color: AppColors.textColor2,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}