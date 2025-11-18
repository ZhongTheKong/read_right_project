# read_right_project

architecture, provider choice(s), setup, privacy notes.

read_right_project
|
|-assets (non-code files used by other files)
|   |-seed_words.csv
|
|-models (widgets used by screens)
|   |-record_button
|
|-providers (the providers of shared data)
|   |-recording_provider
|
|-screens (screens for the app)
|   |-feedback_screen (the screen for showing score and feedback)
|   |-login_screen (the screen for user login)
|   |-practice_screen (the screen for practicing reading)
|   |-progress_screen (the screen for displaying user progress in reading)
|   |-teacher_dashboard_screen (the screen for class scores)
|   |-word_list_screen (the screen for showing words to be used)
|
|-states (placeholder files for states of screens which may be stateful)
|   |-feedback_state (the state for feedback_screen)
|   |-login_state (the state for login_screen)
|   |-practice_state (the state for practice_screen)
|   |-progress_state (the state for progress_screen)
|   |-teacher_dashboard_state (the state for teacher_dashboard_screen)
|   |-word_list_state (the state for word_list_screen)
|
|-templates (just stores SoundDemo for future reference)
|   |-sound_demo (code from sound demo provided on canvas)
|
|-utils (helper classes, structs, and functions for other classes)
|   |-routes (page navigation routes)
|
|-main (app starter)

Milestone 0 Progress
-placeholder ccreens
-placeholder navigation
-placeholder UI
-placeholder provider
-Login screen meets Milestone 1 specifications

Milestone 1 Progress
-Recording provider used throughout
-Recording functionality (start, stop, play)
-Score to feedback
-Seed word lists
-Placeholder STT
-Progress Screen Functionality Done
-Feedback Screen Functionality Done
-Practice Screen Done excluding STT
-Data successfully shared via provider
-Improved CSV file

Milestone 2 Progress
-Separate providers used to maintain data for users, recording, and sessions
-Word list reads from CSV file
-Sync manager logic for audio transcription ready
-App home screen now forces user to login as a student or teacher
-Implemented different flow for students and teacheres
-Wrote logic for Teacher Dashboard
-Implemented a placeholder teacher dashboard
-Word list tracks categories for practice words
-Practice screen indicates when a list of words is complete
-Wrote system where students must score well to advance through the word list
-Placeholder implementation for advancing through the word list
-Improved feedback screen
-Last logged in user, teachers, students and their attempts for word lists are saved to and loaded from json
-Role->Login->Word List->Practice->Feedback->Progress done

SETUP NOTES:
-If you want to use your own CSV file, name it "seed_words.csv" and format it 
in the same way as the current file in our assets folder before adding it to the assets folder.
-When running the app, sign in as a student. Make an account and enter the required information.
-Log in with your new account. 
-Click Go Practice to go to the practice screen. Or, you can sign out from here.
-You can hit record to make a new attempt (Does not work on windows and requires "virtual microphone uses host audio input" enabled)
-Hit stop to end the recording early
-You will be sent to the feedback screen which shows you your score
-If you get a low score, hit Retry Word to go back
-If you get a high score, hit Next Word to progress to next word in list
-Click View Progress to go to the progress screen
-Click Next(temp) to advance to the next word. Eventually you will finish the list and recieve a message.
-Click Go to Word List to go back to the main screen.

KNOWN ISSUES and Future Goals:
-Get STT and Azure AI to work with Android Studio
-Touch up UI
-Save progress in word list separately per student
-Implement Teacher Dashboard with real/json data
-Export CSV/JSON with date ranges from Teacher Dashboard/Progress Screen
-Fix bug that requires users to delete/overwrite account information if their json format is outdated