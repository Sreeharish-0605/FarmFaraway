# 🌾 FarmFarAway

**FarmFarAway** is a smart mobile application designed to help farmers monitor and manage their fields efficiently using IoT technology and AI-driven insights.

## 📱 About the Project

FarmFarAway connects to IoT sensors installed in agricultural fields to collect **real-time data** such as:

- 🌱 Soil Moisture  
- 🌡️ Temperature  
- 💧 Humidity  
- 🧪 Nutrient Levels (NPK)  

This data is visualized on a farmer-friendly mobile dashboard. The app processes sensor input using intelligent algorithms to provide:

- 🔔 **Smart alerts** (e.g., when to irrigate or fertilize)
- 🌾 **Crop recommendations** based on soil and weather conditions
- 💦 **Remote control** of irrigation systems (e.g., drip/sprinkler)

## ⚙️ Features

- 📊 Live sensor dashboard (moisture, temperature, humidity)
- ☁️ Weather forecast integration
- 🧠 AI-powered recommendations
- 📍 Interactive farm mapping
- 🧮 Irrigation calculator
- 🤖 Chatbot assistant
- 📚 Sensor configuration & historical data tracking
- 🌙 Light/Dark Mode Support

## 🔧 Tech Stack

- **Frontend**: Flutter  
- **Backend**: Firebase Realtime Database  
- **IoT Communication**: Sensor data sent wirelessly to Firebase  
- **AI Logic**: In-app rule-based logic (expandable to ML-based)

## 🚀 Getting Started

1. Clone the repository.
2. Ensure Flutter is set up on your system.
3. Configure Firebase using your credentials in `firebase_options.dart`.
4. Run the app:
   ```bash
   flutter pub get
   flutter run
