sealed class CreditsState {}

class CreditsInitial extends CreditsState {}

class CurrentAmountCreditsState extends CreditsState {
  final int credits;

  CurrentAmountCreditsState({required this.credits});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentAmountCreditsState && other.credits == credits;
  }

  @override
  int get hashCode => credits.hashCode;
}

class ErrorCreditsState extends CreditsState {
  final String message;

  ErrorCreditsState({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorCreditsState && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}