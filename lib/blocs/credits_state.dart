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