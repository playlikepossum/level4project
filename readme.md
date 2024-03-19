# Cheyyan

Cheyyan is a time management application designed to gamify the process of managing tasks, improving productivity, and tracking progress. The application incorporates various features aimed at motivating users to efficiently manage their time and achieve their goals.

## File Structure

cheyyan/ \
├── android/ \
├── assets/ \
│ ├── images/ \
│ │ └── cheyyan.png \
├── ios/ \
├── lib/ \
│ ├── auth/ \
│ │ ├── auth_gate.dart \
│ ├── ui/ \
│ │ ├── add_task_page.dart \
│ │ ├── calander.dart   \
│ │ ├── quests_page.dart  \
│ │ ├── login_signup_page.dart \
│ │ └── profile.dart \
│ ├── models/ \
│ | ├── abilites.dart \
│ │ ├── task.dart \
│ ├── services/ \
│ │ ├── notification_service.dart \
│ │ └── theme_service.dart \
│ ├── widgets/ \
│ │ └── button.dart \
│ │ └── input_field.dart \
│ │ └── shopz.dart \
│ │ └── task_tile.dart \
│ └── main.dart \
├── test/ \
├── pubspec.yaml \
└── README.md 


## Build Instructions

### Requirements

* Flutter SDK (version >=3.1.3 <4.0.0)
* Packages listed in `pubspec.yaml`
* Tested on Windows 10

### Build Steps

1. Clone the repository: `git clone https://github.com/your-repo.git`
2. Navigate to the project directory: `cd cheyyan`
3. Run `flutter pub get` to install dependencies.
4. Run `flutter run` to build and run the application on an android emulator running a recenent android version.


### Test Steps

* In the .\src\cheyyan\build\app\outputs\apk\release\app-release.apk section download the apk file and install on an android device
* Start the application by running `flutter run` and verify functionality such as task creation, reminders, and quest completion.

