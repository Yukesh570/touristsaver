import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';

class DiscoveryMembershipWelcomeScreen extends StatelessWidget {
  const DiscoveryMembershipWelcomeScreen({
    super.key,
    required this.membership,
  });

  final DiscoveryMembershipContext membership;

  @override
  Widget build(BuildContext context) {
    final String community = membership.displayCommunityName;
    final String? limitCopy = _limitCopy();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.explore_rounded,
                color: Color(0xFF0009FE),
                size: 62,
              ),
              const SizedBox(height: 22),
              const Text(
                'Welcome to TouristSaver Discovery Membership',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111C44),
                  fontSize: 28,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                membership.sourceName == null &&
                        membership.communityName == null &&
                        membership.campaignName == null
                    ? 'Welcome to the TouristSaver Community'
                    : '$community has invited you to discover TouristSaver.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0009FE),
                  fontSize: 17,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                limitCopy == null
                    ? 'Your Discovery Membership gives you access to participating TouristSaver offers.'
                    : 'Your Discovery Membership gives you access to participating TouristSaver offers $limitCopy.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF63708A),
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enjoy member savings on shopping, dining, attractions, tours and local experiences.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF63708A),
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 26),
              _DiscoveryTermsCard(membership: membership),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: FilledButton(
                  key: const Key('start-discovering-button'),
                  onPressed: () => context.goNamed(
                    'bottom-bar',
                    pathParameters: const {'page': '0'},
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0009FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Start Discovering',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _limitCopy() {
    final int? days = membership.periodDays;
    final double? cap = membership.effectiveSavingsCapAmount;
    final String capText = cap == null
        ? ''
        : '${membership.displayCurrency}${NumberFormat('#,##0.##').format(cap)}';
    if (days != null && cap != null) {
      return 'for up to $days days, or until your verified savings reach $capText';
    }
    if (days != null) return 'for up to $days days';
    if (cap != null) return 'until your verified savings reach $capText';
    return null;
  }
}

class _DiscoveryTermsCard extends StatelessWidget {
  const _DiscoveryTermsCard({required this.membership});

  final DiscoveryMembershipContext membership;

  @override
  Widget build(BuildContext context) {
    final List<Widget> terms = [];
    if (membership.periodDays != null) {
      terms.add(_term(
        Icons.calendar_today_rounded,
        'Membership period',
        '${membership.periodDays} days',
      ));
    }
    if (membership.effectiveSavingsCapAmount != null) {
      terms.add(_term(
        Icons.savings_outlined,
        'Savings limit',
        'Up to ${membership.displayCurrency}${NumberFormat('#,##0.##').format(membership.effectiveSavingsCapAmount)}',
      ));
    }
    if (terms.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F3)),
      ),
      child: Column(children: terms),
    );
  }

  Widget _term(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0009FE), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF111C44),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF63708A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
