abstract class Event<T> {
  /// The value wrapped by this event
  final T value;

  /// `value` may be `null` in events that don't transport any meaningful data.
  Event(this.value);
}

class OnPaymentSessionDone extends Event<String> {
  OnPaymentSessionDone(super.value);
}
class OnPaymentAdvancedDone extends Event<String> {
  OnPaymentAdvancedDone(super.value);
}

class OnStart extends Event<void> {
  OnStart(super.value);
}

class OnPaymentError extends Event<String> {
  OnPaymentError(super.value);
}
