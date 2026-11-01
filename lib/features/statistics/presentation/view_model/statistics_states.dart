import '../../data/models/statistics_model.dart';

abstract class StatisticsStates {}

class StatisticsInitState extends StatisticsStates {
  @override
  String toString() => 'StatisticsInitState';
}

class StatisticsLoadingState extends StatisticsStates {
  @override
  String toString() => 'StatisticsLoadingState';
}

/// Emitted while reloading (month change / pull to refresh) when data is
/// already on screen, so the page keeps its content instead of flashing a
/// full-screen loader.
class StatisticsRefreshingState extends StatisticsStates {
  @override
  String toString() => 'StatisticsRefreshingState';
}

class StatisticsSuccessState extends StatisticsStates {
  final StatisticsModel statisticsModel;
  StatisticsSuccessState(this.statisticsModel);

  @override
  String toString() => 'StatisticsSuccessState';
}

class StatisticsDateSelectedState extends StatisticsStates {
  final Days? day;
  StatisticsDateSelectedState(this.day);

  @override
  String toString() => 'StatisticsDateSelectedState(date: ${day?.date})';
}

class StatisticsErrorState extends StatisticsStates {
  final String error;
  StatisticsErrorState(this.error);

  @override
  String toString() => 'StatisticsErrorState(error: $error)';
}
