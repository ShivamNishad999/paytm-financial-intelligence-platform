# GrowSAATHI — Mobile App (Phase 1 + Phase 2 offline demo)

AI-Powered Merchant Growth Partner — Flutter client for the existing Spring Boot `growsaathi` backend.

## Phase 2 additions (offline demo modules)

Every "Coming Soon" screen from Phase 1 is now a working offline screen, backed by local/mock data —
none of these call the real backend yet, since the endpoints they'd need either don't exist server-side
(Actions, Chat is closest) or the scope was explicitly "no real API, store locally" (Campaigns):

- **Insights** (`screens/insights/insights_screen.dart`, `providers/insight_provider.dart`,
  `models/insight/insight_model.dart`) — date filter (7/30 days, this month), sales trend, customer
  growth, product performance, inventory health, best-sellers, top customers. Seeded/deterministic mock
  data via `services/insight/insight_service.dart`.
- **Action Center** (`screens/actions/actions_screen.dart`, `providers/action_provider.dart`,
  `models/actions/action_item_model.dart`) — Pending/Approved/Completed/Dismissed tabs, with
  Approve/Mark as Done/Dismiss changing local state only. The real backend has no `Action` entity yet
  (see the backend API mapping) — `core/repositories/recommendation_repository.dart` is the interface a
  future backend-backed version would implement.
- **Campaigns** (`screens/campaigns/`, `providers/campaign_provider.dart`,
  `models/campaign/campaign_model.dart`) — Draft/Scheduled/Sent tabs, a create-campaign form with a
  WhatsApp/SMS-style message preview, all stored in-memory. No message is ever actually sent.
- **AI Assistant** (`screens/chat/chat_screen.dart`, `providers/chat_provider.dart`,
  `services/chat/offline_ai_service.dart`) — the floating "Ask GrowSAATHI" button now opens a real chat
  UI (bubbles, typing indicator, timestamps, suggested-question chips). Answers come from
  `OfflineAiService`, a local rule-based "knowledge service" over the same demo numbers used elsewhere
  in the app — the same kind of keyword-matching the real backend's `/api/ai/chat` uses server-side (see
  the AI reality check in the backend mapping), just running on-device. `AiService` is an interface so a
  `LiveAiService` calling the real endpoint can replace it later without touching the chat UI.
- **Live API Mode** (`providers/dashboard_provider.dart`, `core/constants/live_api_status.dart`) — the
  toggle now actually switches `DashboardService` between demo and live calls. A failed live call
  (timeout, offline, or server error — `ApiClient`'s existing error mapping) falls back to demo data
  automatically and the Home screen banner / More screen say so explicitly, rather than silently mixing
  the two.
- **Backend-ready repository interfaces** (`core/repositories/*.dart`) — `SalesRepository`,
  `CustomerRepository`, `InventoryRepository`, `CampaignRepository`, `RecommendationRepository`.
  Interfaces only, matching the shape the current mock/local services already provide, so any future
  backend implementation slots in by adding one class per interface — no screen or provider changes.

## What's in this drop

Phase 1 only, per the build plan:

- Project structure (clean architecture: `core` / `models` / `services` / `providers` / `screens` / `widgets`)
- Theme (`lib/app/theme.dart`) using the brand palette from the design brief
- Routing (`lib/app/routes.dart`) via `go_router`, with a `StatefulShellRoute` bottom-nav shell
- Splash screen → mock Login → Dashboard
- Main navigation shell: Home / Insights / Actions / Campaigns / More + global "Ask GrowSAATHI" FAB
  (the four non-Home tabs are intentional `UnderConstructionScreen` placeholders — not yet in scope)
- Dashboard screen: KPI cards, 7-day sales chart (`fl_chart`), Quick Insights + AI Recommendations
  preview, pull-to-refresh, skeleton loading, friendly error state
- `ApiClient` (Dio) abstraction, `DashboardService`, `dashboardProvider` (Riverpod)
- Dashboard-related Dart models with `fromJson` matching the real backend response shapes
- Demo Mode (bundled mock JSON) vs Live API Mode, switchable from the Home screen banner or the More tab

Not implemented yet (by design, per this phase's scope): Customers, Products, Campaigns, Chatbot,
Notifications, Action Center detail/approval flow.

## Key decisions baked into this code (from the backend API mapping)

1. **Mock/local auth only.** There is no `/api/auth/*` endpoint on the backend. `MockAuthService`
   accepts any non-empty identifier/password. `AuthService` is an interface so a real implementation
   can be swapped in later without touching the Login screen.
2. **`GET /api/dashboard` is the canonical dashboard endpoint** (not `/api/dashboard/summary`), since it
   already returns sales, customers, products, inventory, campaigns, daily sales and opportunities in
   one call.
3. **`GET /api/ai-recommendations` is treated as canonical** over `/api/recommendations` (the two overlap
   heavily) — call sites in `ApiEndpoints` only reference the former.
4. **No merchant scoping exists on the backend yet.** The Home screen's mode banner explicitly says so
   in Live API Mode rather than silently presenting whole-dataset totals as one merchant's numbers.
5. **No fabricated AI numbers.** `OpportunityModel`/`OpportunityCard` never show an "expected impact %" —
   the backend doesn't supply one.
6. **Demo and Live are never mixed.** `appModeProvider` is the single source of truth; `dashboardProvider`
   watches it and picks `DashboardService.getDemoDashboardData()` or `.getDashboardData()` accordingly.

## Running this

This drop ships `lib/`, `assets/`, and `pubspec.yaml` only (no `android/`/`ios/` platform folders, since
those are machine-generated). To run it:

```bash
flutter create --project-name growsaathi --org com.growsaathi .   # generates android/ios/etc. in place
flutter pub get
flutter run
```

If `flutter create .` complains about existing files, create a fresh scaffold elsewhere and copy this
`lib/`, `assets/`, and `pubspec.yaml` over it instead.

### Pointing at your backend

Edit `lib/core/network/app_config.dart`:

- Android emulator → `http://10.0.2.2:8080` (already set)
- Physical device / iOS simulator → your machine's LAN IP, e.g. `http://192.168.1.20:8080`

Then flip **Live API Mode** from the Home screen banner or the More tab. Make sure the Spring Boot app
is running (`mvn spring-boot:run` in the backend project) and reachable on that address — its CORS
allowlist only covers `localhost:5500`/`127.0.0.1:5500` today, which affects browser-based testing only
(a native Android/iOS client is not subject to browser CORS).

## Next phases

Phase 2 (Insights, Recommendations detail, Action Center — read-only), Phase 3 (Campaigns, Customers,
Products, Inventory), Phase 4 (Chatbot) follow the same pattern: one service per domain wrapping the
exact endpoints listed in the backend API mapping doc, one provider, one screen — no new endpoints
invented, no business logic duplicated from the backend.
