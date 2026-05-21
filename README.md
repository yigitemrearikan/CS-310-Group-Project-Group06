# Wear2Weather 
*An App For Indecisive People* Ensuring users wear the most efficient and comfortable outfit based on their specific environment and activities.  

---

##  Project Overview  
In the modern Age of Technology, users should not have to struggle with the daily *"What to wear?"* dilemma.  
**Wear2Weather** aims to eliminate this issue caused by unpredictable weather changes and personal indecisiveness.  

---

##  Key Objectives  
* **Personalized Comfort**: Matching real-time weather data to individual temperature tolerance.  
* **Smart Wardrobe**: Tracking outfit history to help users utilize their entire wardrobe effectively.  
* **Activity Context**: Providing specific suggestions for *Office*, *Running*, or *Campus*.  

---

##  Team (Group 6)  
* Yiğit Emre Arıkan (ID: 34011) – *Project Coordinator* * Kerem Kaya (ID: 33917) – *Testing & Quality Assurance Lead* * Barkın Uzunel (ID: 34039) – *Documentation & Submission Lead* ---

##  Tech Stack & Architecture  
* **Framework**: Flutter (Channel stable)  
* **Backend Services**: Firebase Authentication, **Firebase Realtime Database** (for storing User Profiles and Digital Wardrobe), and Firebase Storage (for images).
* **State Management**: [Buraya kullandığınız state management yapısını yazın, örn: Provider / Riverpod]
* **User Profiles**: Stores location and Personal Comfort Index.  
* **Weather Cache**: Cached forecasts to optimize performance and API costs.  

---

##  Features  
* **Dynamic Weather Forecast**: Real-time updates to prevent "too hot/too cold" moments.  
* **Personalized User Profile**: Custom settings based on location and preferences.  
* **Activity/Location Based Advice**: Context-aware suggestions.  
* **Personalized Comfort and Health Index**: A custom metric combining wind and humidity with personal tolerance.  

---

##  Prerequisites & Installation

### Flutter Version Requirements
* Flutter SDK: `>=3.0.0` 

### Firebase Setup & Configuration
1. Connect your local environment to the Firebase project.
2. Ensure you have enabled **Authentication** and **Realtime Database** in your Firebase Console.
3. Place your `google-services.json` file inside the `android/app` directory and your `GoogleService-Info.plist` inside the `ios/Runner` directory.
4. If modifying database rules, ensure Realtime Database read/write access is properly authenticated.

### Running the Application
To run the application, execute the following commands in your terminal:

```bash
# Fetch all required dependencies
flutter pub get

# Run the app on your emulator or physical device
flutter run
