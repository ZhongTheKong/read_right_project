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

Future Goals
-Find a way to get STT to work on Windows Android Emulator
-Implement STT into feedback
-Save feedback using local storage
-Save attempts list locally
-Allow sorting via username for attempts
-Allow importing word lists directly from CSV files into code
-Touch up UI and naviagation