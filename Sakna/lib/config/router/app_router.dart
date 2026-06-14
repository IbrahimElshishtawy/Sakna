import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/terms_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/provider_profile/presentation/screens/technician_profile_screen.dart';
import '../../features/booking/presentation/screens/bookings_screen.dart';
import '../../features/live_tracking/presentation/screens/live_tracking_screen.dart';
import '../../features/scheduling/presentation/screens/booking_setup_screen.dart';
import '../../features/booking/presentation/screens/add_order_details_screen.dart';
import '../../features/address_management/presentation/screens/select_address_screen.dart';
import '../../features/booking/presentation/screens/booking_summary_screen.dart';
import '../../features/payments/presentation/screens/payment_methods_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/complete-profile',
      builder: (context, state) => const CompleteProfileScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/technician-profile',
      builder: (context, state) => const TechnicianProfileScreen(),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) => const LiveTrackingScreen(),
    ),
    GoRoute(
      path: '/booking-setup',
      builder: (context, state) => const BookingSetupScreen(),
    ),
    GoRoute(
      path: '/add-order-details',
      builder: (context, state) => const AddOrderDetailsScreen(),
    ),
    GoRoute(
      path: '/select-address',
      builder: (context, state) => const SelectAddressScreen(),
    ),
    GoRoute(
      path: '/booking-summary',
      builder: (context, state) => const BookingSummaryScreen(),
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    // ShellRoute for persistent bottom tab bar layout

    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
