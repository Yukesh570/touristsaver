//Initializing the flutter stripe
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:new_piiink/constants/env.dart';
import 'package:new_piiink/constants/pref.dart';
import 'package:new_piiink/constants/pref_key.dart';

initializeFlutterStripe() async {
  Stripe.publishableKey = await Pref().readData(key: savePublishableKey);
  // stripePublishableKey; // set the publishable key for Stripe - this is mandatory
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  await Stripe.instance.applySettings();
}

byDefaultStripeKey() async {
  Pref().writeData(key: savePublishableKey, value: stripePublishableKey);

  Stripe.publishableKey = await Pref().readData(key: savePublishableKey);
  // stripePublishableKey; // set the publishable key for Stripe - this is mandatory
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  await Stripe.instance.applySettings();
}
