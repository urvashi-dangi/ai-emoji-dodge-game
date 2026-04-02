# 🧠 Codex Prompts – Emoji Dodge (Flutter Game)

This document provides a complete prompt to generate a **fully playable Flutter mobile game** called **Emoji Dodge** using Codex or any AI code generator.

---

## 🎯 Objective

Create a complete Flutter mobile game where:
- The player avoids falling emojis
- The game becomes progressively harder
- Score increases based on survival time

---

## 📋 Core Requirements

- The game must be **fully playable and runnable**
- Use **Flutter (Dart) only**
- Avoid external game engines (e.g., Flame) unless absolutely necessary
- Organize code into **clean, modular files**

---

## 🎮 Game Overview

- The player controls a character at the **bottom of the screen**
- Emojis fall continuously from the **top**
- The goal is to **avoid collisions**
- The player survives as long as possible
- Score increases based on survival duration

---

## 🧱 App Structure

### 1. Home Screen

- Display title: **"Emoji Dodge"**
- Show a **Start Game** button
- Optionally display:
    - Last score
    - Best score
- On button tap → Navigate to **Game Screen**

---

### 2. Game Screen

#### Player
- Positioned at the **bottom**
- Represented by:
    - A simple shape (circle) OR
    - An emoji/avatar

#### Emojis (Obstacles)
- Fall from the top continuously
- Randomized:
    - Position (X-axis)
    - Speed
    - Emoji type (😂🔥💣👾)

#### Controls
- Player moves:
    - Left / Right using drag gestures

#### Game Loop
- Use:
    - `Ticker` OR
    - `AnimationController` OR
    - `Timer.periodic`
- Ensure smooth updates (~60 FPS)

#### Collision Detection
- Use bounding box logic
- If collision occurs:
    - Trigger Game Over

#### Score System
- Increase score over time
- Display current score at the top

---

## 💀 Game Over Flow

Display dialog or overlay with:
- Title: **Game Over**
- Final Score
- Buttons:
    - Restart Game
    - Back to Home

---

## ⚙️ Technical Requirements

- Use `StatefulWidget` where required
- Maintain state for:
    - Player position
    - Emoji list (position, speed, type)
    - Score
- Efficient game loop implementation
- Smooth performance (target ~60 FPS)
- Proper navigation using `Navigator`

---

## 🎨 UI / UX Guidelines

- Keep UI simple and clean
- Use bright colors and emojis
- Ensure responsive layout for different screen sizes
- Maintain smooth animations

---

## 🚀 Bonus Features (Optional)

- Increasing difficulty over time:
    - Faster emojis
    - Higher spawn rate
- Multiple emoji types
- Sound effects
- Pause / Resume functionality
- High score persistence

---

## 📦 Deliverables

- Complete Flutter project code
- `main.dart` entry point
- Well-structured files (separate screens, logic)
- Clear comments explaining core logic
- No placeholder or incomplete code
- Must be **fully runnable without errors**

---