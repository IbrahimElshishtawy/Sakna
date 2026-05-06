import 'package:flutter/material.dart';
import 'package:khidma/features/customer/AboutUs/AboutUsPage.dart';
import 'package:khidma/features/customer/ContactSupport/ContactSupportPage.dart';
import 'package:khidma/features/customer/AddressBook/AddressBookPage.dart';
import 'package:khidma/features/customer/FAQ/FAQPage.dart';
import 'package:khidma/features/customer/LanguageSettings/LanguageSettingsPage.dart';
import 'package:khidma/features/customer/Notification/NotificationDetailPage.dart';
import 'package:khidma/features/customer/Notification/NotificationPage.dart';
import 'package:khidma/features/customer/Notification/NotificationSettingsPage.dart';
import 'package:khidma/features/customer/PrivacyPolicy/PrivacyPolicyPage.dart';
import 'package:khidma/features/customer/Tasks/TaskDetailPage.dart';
import 'package:khidma/features/customer/Tasks/TasksPage.dart';
import 'package:khidma/features/customer/TermsCondition/TermsConditionsPage.dart';
import 'package:khidma/features/customer/Wishlist/WishlistPage.dart';
import 'package:khidma/features/customer/customer_chat/coustomer_chatDetail.dart';
import 'package:khidma/features/customer/customer_chat/customer_chat.dart';
import 'package:khidma/features/customer/customer_home_screen/HomeScreen.dart';
import 'package:khidma/features/customer/customer_profile/EditProfilePage.dart';
import 'package:khidma/features/customer/order/OrderHistoryPage.dart';
import 'package:khidma/features/customer/payment_screen.dart';
import 'package:khidma/features/customer/rating_payment/rating_payment_screen.dart';

import '../features/auth/role_selection_screen.dart';
import '../features/auth/customer_login_screen/customer_login_screen.dart';
import '../features/auth/helper_login_screen/helper_login_screen.dart';
import '../features/auth/presentation/pages/onboarding_screen.dart' as new_onboarding;
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';

import '../features/customer/customer_home_screen/customer_home_screen.dart';
import '../features/customer/order/service_details_screen.dart';
import '../features/customer/searching_helper_screen.dart';
import '../features/customer/matched_helper_screen.dart';
import '../features/customer/mission_in_progress_screen.dart';
import '../features/customer/customer_profile/customer_profile_screen.dart';
import '../features/customer/setting/settings_screen.dart';

import '../features/helper/helper_home_screen.dart';
import '../features/helper/job_details_screen.dart';
import '../features/helper/helper_mission_tracking_screen.dart';
import '../features/helper/earnings_history_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String roleSelection = '/role-selection';
  static const String customerLogin = '/customer-login';
  static const String helperLogin = '/helper-login';
  static const String login = '/login';
  static const String register = '/register';

  static const String customerHome = '/customer-home';
  static const String serviceDetails = '/service-details';
  static const String searchingHelper = '/searching-helper';
  static const String matchedHelper = '/matched-helper';
  static const String missionInProgress = '/mission-in-progress';
  static const String ratingPayment = '/rating-payment';
  static const String payment = '/payment';
  static const String customerProfile = '/customer-profile';
  static const String settings = '/settings';

  static const String helperHome = '/helper-home';
  static const String jobDetails = '/job-details';
  static const String helperMissionTracking = '/helper-mission-tracking';
  static const String earningsHistory = '/earnings-history';
  static const String chats = '/chats';
  static const String chatDetail = '/chat-detail';
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notification-detail';
  static const String notificationSettings = '/notification-settings';
  static const String faq = '/faq';
  static const String contactSupport = '/contact-support';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String aboutUs = '/about-us';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';
  static const String languageSettings = '/language-settings';
  static const String paymentMethods = '/payment-methods';
  static const String orderHistory = '/order-history';
  static const String wishlist = '/wishlist';
  static const String addressBook = '/address-book';
  static const String tasks = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String taskTracking = '/task-tracking';
  static const String taskReview = '/task-review';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const new_onboarding.OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());

      case customerLogin:
        return MaterialPageRoute(builder: (_) => const CustomerLoginScreen());

      case helperLogin:
        return MaterialPageRoute(builder: (_) => const HelperLoginScreen());

      case customerHome:
        return MaterialPageRoute(builder: (_) => const CustomerHomeScreen());

      case serviceDetails:
        return MaterialPageRoute(builder: (_) => const ServiceDetailsScreen());

      case searchingHelper:
        return MaterialPageRoute(builder: (_) => const SearchingHelperScreen());

      case matchedHelper:
        return MaterialPageRoute(builder: (_) => const MatchedHelperScreen());

      case missionInProgress:
        return MaterialPageRoute(
          builder: (_) => const MissionInProgressScreen(),
        );

      case ratingPayment:
        return MaterialPageRoute(builder: (_) => const RatingPaymentScreen());

      case customerProfile:
        return MaterialPageRoute(builder: (_) => const CustomerProfileScreen());

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case helperHome:
        return MaterialPageRoute(builder: (_) => const HelperHomeScreen());

      case jobDetails:
        return MaterialPageRoute(builder: (_) => const JobDetailsScreen());

      case helperMissionTracking:
        return MaterialPageRoute(
          builder: (_) => const HelperMissionTrackingScreen(),
        );

      case earningsHistory:
        return MaterialPageRoute(builder: (_) => const EarningsHistoryScreen());
      case chats:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case chatDetail:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final chatId = args['chatId'] as int;
        return MaterialPageRoute(
          builder: (_) => ChatDetailPage(chatId: chatId),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case notificationDetail:
        return MaterialPageRoute(
          builder: (_) => const NotificationDetailPage(),
        );
      case notificationSettings:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsPage(),
        );
      case faq:
        return MaterialPageRoute(builder: (_) => const FAQPage());
      case contactSupport:
        return MaterialPageRoute(builder: (_) => const ContactSupportPage());
      case termsConditions:
        return MaterialPageRoute(builder: (_) => const TermsConditionsPage());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
      // case changePassword:
      //   return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case languageSettings:
        return MaterialPageRoute(builder: (_) => const LanguageSettingsPage());
      case paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryPage());
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistPage());
      case addressBook:
        return MaterialPageRoute(builder: (_) => const AddressBookPage());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TasksPage());
      case taskDetail:
        return MaterialPageRoute(builder: (_) => const TaskDetailPage());
      default:
        return MaterialPageRoute(builder: (_) => const new_onboarding.OnboardingScreen());
    }
  }
}
