/// Abstraction the chat provider talks to — mirrors `AuthService`'s
/// pattern so a real backend can be wired in later without touching
/// the chat UI. The real backend already exposes `POST /api/ai/chat`
/// (see the backend API mapping) with the same "keyword rules over
/// real data" behaviour this offline version reproduces locally; a
/// `LiveAiService implements AiService` calling that endpoint is the
/// natural next step once Live API Mode needs it.
abstract class AiService {
  Future<String> ask(String question);
}
