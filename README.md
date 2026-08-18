# Kapuut

Kapuut is a quiz game developed as a project for the **ITU** course at the **Faculty of Information Technology, Brno University of Technology (FIT VUT)**.

The game combines educational quizzes with casual game mechanics and supports both individual practice and multiplayer gameplay on a single device.

## Features

* **Flashcards / Training** – practice questions and track your progress.
* **PvP Quiz** – competitive quiz for multiple players on one device.
* **Wheel of Fortune** – spin the wheel and answer questions to earn coins.
* **Daily Tasks** – complete daily challenges and receive rewards.
* **Profiles** – create and customize player profiles with avatars and backgrounds.
* **Coins and ELO** – earn rewards and track competitive progress.
* **Quiz Topics** – choose from available game categories.
* **Offline Gameplay** – the game does not require an internet connection.

## Authors

**Team Chleba**

* Šimon Schön (`xschons00`)
* Kamil Jakubčák (`xjakubk00`)
* Adrián Pitka Kester (`xpitkaa00`)

## Technology

* Godot Engine
* GDScript
* Local data storage

## Project Structure

The project is organized into separate directories for data access, Godot scenes, reusable UI components, and game logic.

```text
src/                             #Root directory containing the application logic, data, and Godot scenes.
├── DAL/
│   ├── DataAccess/              # Access to individual parts of the data model
│   └── DataObjects/             # Data objects representing application entities
│
├── scenes/                      #Contains all Godot scenes used by the application.
│   ├── components/              # Reusable UI components
│   ├── FlashCardGame/            # Training mode scenes
│   └── PvPGame/                  # Local multiplayer scenes
│
└── scripts/                      #Contains scripts controlling the behavior of scenes and UI components.
    ├── components/               # Logic for reusable UI components
    ├── FlashCardGame/            # Training mode game logic
    └── PvPGame/                  # Competitive game mode logic
```

## Running the Game

Open the project in Godot Engine and run the main scene/project.

The game is designed to run locally without an internet connection.

