abstract class AppStates {}

class AppInitialState extends AppStates {}

class ChangeBottomNavState extends AppStates {}

class TextDirectionState extends AppStates {}

class TranslationSuccessState extends AppStates {}

class TranslationLoadingState extends AppStates {}

class TranslationErrorState extends AppStates {}

class ChangeToolBarState extends AppStates {}

class ShowSourceItemsState extends AppStates {}

class ChangeSourceLabelState extends AppStates {}

class PlaySoundState extends AppStates {
  String? text;
  int? currentWordIndex;
  int? currentWordPosition;
  PlaySoundState(this.text, this.currentWordIndex, this.currentWordPosition);
}

class PauseSoundState extends AppStates {}

class StopSoundState extends AppStates {}

class GetVoiceSuccessState extends AppStates {}

class GetVoiceLoadingState extends AppStates {}

class GetVoiceErrorState extends AppStates {}

// Adding Card States //
class AddCardLoadingState extends AppStates {}

class AddCardSuccessState extends AppStates {}

class AddCardErrorState extends AppStates {}

// Getting Card States //
class GetCardsLoadingState extends AppStates {}

class GetCardsSuccessState extends AppStates {}

class GetCardsErrorState extends AppStates {}
