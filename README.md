Recording of the application running: https://baudom-my.sharepoint.com/:v:/g/personal/aak258_student_bau_edu_lb/EdoE8cWgPHFJli6CFWrqIPEBJ5OIvlxKGWe1ZajCeR2nQw?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=FNIcfd
A Flutter application for user authentication and weather features, following clean architecture and best practices.

## Overview
This app demonstrates a modular Flutter project with clean architecture, state management using Riverpod, and responsive UI. It includes user login and signup flows as a foundation for further weather-related features.

## Features
- User authentication (login & signup)
- State management with Riverpod
- Clean architecture principles
- Responsive UI design
- Extensible for weather data integration

## Project Structure
```
lib/
  core/                # Core utilities and shared code
  features/
    auth/              # Authentication feature (data, domain, presentation)
      data/
      domain/
      presentation/
    ...                # Other features (e.g., weather)
  main.dart            # App entry point
```

## State Management
- Uses [Riverpod](https://riverpod.dev/) for robust and testable state management.
- Each form (login, signup) has its own StateNotifier and provider.
