sealed class CreditsEvent {}

class GetCreditsEvent extends CreditsEvent {}

class AddCreditsEvent extends CreditsEvent {
  final int amount;

  AddCreditsEvent(this.amount);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddCreditsEvent &&
      other.amount == amount;
  }

  @override
  int get hashCode => amount.hashCode;
}

class WithdrawCreditsEvent extends CreditsEvent {
  final int amount;

  WithdrawCreditsEvent(this.amount);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WithdrawCreditsEvent &&
      other.amount == amount;
  }

  @override
  int get hashCode => amount.hashCode;
}