# Khidma App: Technical Specification & Analysis

## 1. Feature Analysis & Prioritization

The features are categorized to support a staged rollout (MVP to Advanced).

| # | Feature | Priority | Implementation Strategy |
|---|---|---|---|
| 1 | Urgent Service | MVP | Price multiplier (1.5x) if `isUrgent` is true. Push notifications to nearby helpers. |
| 2 | Geoproximity | MVP | Haversine formula for distance calculation. Store lat/lng in User and Task models. |
| 3 | Pro Provider | Advanced | `subscriptionType` flag. Boosted sort order in results. |
| 4 | Subscriptions | Advanced | Stripe/Apple Pay integration for Basic/Pro/Premium tiers. |
| 5 | Discounts | Advanced | Coupon code field in payment. Validation against expiry and usage limit. |
| 6 | Protection/Reporting| MVP | Reporting API for users/tasks. Admin dashboard review. |
| 7 | Advanced Rating | MVP | Breakdown of speed, quality, and communication in Rating model. |
| 8 | Smart Recomms | Advanced | Frequency-based and location-based filtering. |
| 9 | Seasonal Services | MVP | Home screen banners for Ramadan, Summer, etc. |
| 10| Favorites | Advanced | many-to-many relationship between User and Service/Helper. |
| 11| Repeat Order | Advanced | 'Re-order' button that clones TaskRequest with current date/time. |
| 12| Wallet | Advanced | Internal credit system with transaction history. |
| 13| Escrow (Guaranty)| MVP | Funds held in 'Pending' status until both parties confirm completion. |
| 14| Negotiation | Advanced | Real-time chat with 'Offer' and 'Accept' interactive cards. |
| 15| Scheduling | MVP | Calendar/Time picker in task creation. |
| 16| Badges | MVP | Automated badges like 'Top Rated' based on rating/jobs count. |
| 17| Statistics | Advanced | Dashboard showing earnings, jobs count, and spending. |
| 18| User Status | MVP | `onlineStatus` (Online/Offline) and `availabilityStatus` (Available/Busy). |
| 19| Smart Search | Advanced | Algolia or Elasticsearch for fuzzy searching. |
| 20| In-app Ads | Advanced | Promoted helpers/services in top slots. |
| 21| Points/Levels | Advanced | Gamification: earn points for every job, level up for fee discounts. |
| 22| Technical Support | MVP | Live chat integration (Zendesk or custom BLoC chat). |
| 23| Referral | Advanced | Referral codes generating wallet credit on first transaction. |
| 24| Teamwork | Advanced | Allow multiple helpers to apply for a single high-value task. |
| 25| Arrival Confirm | MVP | Geofencing + 'Arrived' button for helpers. |
| 26| Order Tracking | MVP | Visual stepper showing Pending -> Matched -> In Progress -> Completed. |
| 27| Execution Photos | MVP | Image upload capability during task execution. |
| 28| Smart Pricing | Advanced | Dynamic suggestions based on average prices in the area. |
| 29| Multi-language | MVP | localization (AR/EN) using `flutter_localizations`. |
| 30| Dark/Light Mode | MVP | BLoC-driven theme management. |

---

## 2. Data Models

### KhidmaUser
- `id`: String
- `name`: String
- `role`: Enum (client, helper)
- `city`: String
- `location`: GeoPoint (lat, lng)
- `rating`: Double
- `avatarUrl`: String
- `subscriptionType`: Enum (basic, pro, premium)
- `badges`: List<Badge>
- `walletBalance`: Double
- `onlineStatus`: Enum (online, offline)
- `availabilityStatus`: Enum (available, busy)

### Order / TaskRequest
- `id`: String
- `clientId`: String
- `helperId`: String?
- `serviceType`: String
- `description`: String
- `isUrgent`: Boolean
- `scheduledAt`: DateTime
- `price`: Double
- `status`: Enum (pending, matched, in_progress, completed, disputed)
- `photos`: List<String>
- `ratingBreakdown`: Map<String, Double> (speed, quality, comms)

---

## 3. API Endpoints

- `POST /tasks/create`: Create new task.
- `GET /tasks/nearby`: Fetch tasks based on lat/lng.
- `POST /tasks/{id}/apply`: Helper applies for task.
- `POST /tasks/{id}/arrive`: Helper confirms arrival.
- `POST /tasks/{id}/upload-photo`: Upload progress photo.
- `GET /user/profile`: Fetch profile with stats and badges.
- `POST /wallet/deposit`: Add funds.
- `GET /services/seasonal`: Fetch active seasonal offers.

---

## 4. BLoC Architecture (Flutter)

- **TaskBloc**: Handles `CreateTaskEvent`, `FetchTasksEvent`, `UpdateTaskStatusEvent`.
- **UserBloc**: Handles `UpdateProfileEvent`, `ChangeSubscriptionEvent`, `ToggleThemeEvent`.
- **ChatBloc**: Handles real-time messaging and price negotiations.

---

## 5. UI/UX Suggestions

- **Home Screen**: Large search bar at top, followed by Seasonal Banners, then Service Categories.
- **Urgent Toggle**: Bright orange toggle on the task creation screen to indicate priority.
- **Tracking Stepper**: High-contrast progress bar during task execution.
- **Dark Mode**: High readability contrast for Arabic fonts.
