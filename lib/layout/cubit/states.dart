abstract class AppStates {}

class AppInitialState extends AppStates {}

class ChangeBottomNavState extends AppStates {}

class ChangeSwitchModeState extends AppStates {}

class ChangeAppModeState extends AppStates {}

class ChangeAppLanguageState extends AppStates {}

class TextDirectionState extends AppStates {}

class TranslationSuccessState extends AppStates {}

class TranslationLoadingState extends AppStates {}

class TranslationErrorState extends AppStates {}

class SeachedCardsStates extends AppStates {}

class EmptySearchedCardsState extends AppStates {}

class ChangeFontSizeState extends AppStates {}

class UpdateCachedSourcesState extends AppStates {}

// Get User States //
class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {}

//Sign Out States //
class SignOutSuccessState extends AppStates {}

class SignOutErrorState extends AppStates {}

// Delete User State //
class DeleteUserSuccessState extends AppStates {}

class DeleteUserLoadingState extends AppStates {}

class DeleteUserErrorState extends AppStates {}

// Email and pass check for deactivate account //

class ProvidedEmailAndPassSuccessState extends AppStates {}

class ProvidedEmailAndPassErrorState extends AppStates {}

// Password Reset State

class SendPasswordResetLoadingState extends AppStates {}

class SendPasswordResetSuccessState extends AppStates {}

class SendPasswordResetErrorState extends AppStates {}

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

// Delete Card States //
class DeleteCardSuccessState extends AppStates {}

// Update Card States //

class UpdateCardLoadingState extends AppStates {}

class UpdateCardSuccessState extends AppStates {}

class UpdateCardErrorState extends AppStates {}

// Generating Exam States //

class GenrateExamLoadingState extends AppStates {}

class GenrateExamSuccessState extends AppStates {}

class GenrateExamErrorState extends AppStates {}

class GoToNextQuestionLoadingState extends AppStates {}

class GoToNextQuestionSuccessState extends AppStates {}

class GoToNextQuestionErrorState extends AppStates {}

class ChangeAnswerColor extends AppStates {}

class GetEditedWordsEmptyState extends AppStates {}

// Extract Text From Image

class GetTextFromImageSuccessState extends AppStates {}

class GetTextFromImageLoadingState extends AppStates {}

class GetTextFromImageErrorState extends AppStates {}

// Cancel Exam

class CancelExamSuccessState extends AppStates {}
