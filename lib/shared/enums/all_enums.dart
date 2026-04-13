enum AlertType { orderAccepted, orderComplete, cancelOrder }

enum CallType { audio, video }

enum MessageStatus { sending, sent, delivered, read, failed }

// ─── Call state ───────────────────────────────────────────────
enum CallState { ringing, connecting, connected, ended }

// ─── Model ────────────────────────────────────────────────────
enum TransactionType { deposit, refund }

enum StaticPageType {
  privacy,
  terms,
  refundPolicy,
  shippingPolicy,
  aboutUs,
  location,
  copyRight,
  footerText,
}
