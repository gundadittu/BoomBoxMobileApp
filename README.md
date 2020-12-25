# BoomBoxApp

## Building and Running App
- preparing dev environment: https://flutter.dev/docs/get-started/install
- open emulated device (via AVD manager in Android studio or Simulator app for iOS)
- execute "flutter run" from project root 
- app should be running on simulator now

- other helpful commands: "flutter clean", "flutter build ios", "flutter doctor -v"

## General Flutter Resources
- good udemy course for flutter dev: https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/

- official flutter docs: https://flutter.dev/docs
- widget catalog: https://flutter.dev/docs/development/ui/widgets 

## Understanding Firebase  + Flutter Integration
- https://firebase.flutter.dev/
- https://www.digitalocean.com/community/tutorials/flutter-firebase-setup
- https://medium.com/firebase-developers/dive-into-firebase-auth-on-flutter-email-and-link-sign-in-e51603eb08f8

## DevTools
- https://flutter.dev/docs/development/tools/devtools/overview
- Installing cli: https://flutter.dev/docs/development/tools/devtools/cli

## Apple Music Integration
- Tutorial: https://crunchybagel.com/integrating-apple-music-into-your-ios-app/
- JSON Web Token (JWT) Intro: https://jwt.io/introduction/
- JWT Online Demo: https://crunchybagel.com/integrating-apple-music-into-your-ios-app/
- Apple - Creating a Developer Token: https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens
---> NEED TO DO THIS EVERY 6 Months.

## Apple Music Credential Generation: 
- developer token: "eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJKUTRLOEVFNzdQIiwiaWF0IjoxNjA4MzQ0MTQ0LCJleHAiOjE1Nzc3MDAwfQ.T2eVrCZl7XQC5S1nkOizl3m45jD-v_l0oZhOt-5l0wb5TQvxGRIahnYtFk8g1OsJvIqT73-HxlhAEiRnQc6iYw"
    - Used this python library to generate dev token: https://github.com/pelauimagineering/apple-music-token-generator
    - Created 12/18/2020
    - Stored in ios/Runner.xcodeproj/Runner/AppDelegate.swift 
- private key: "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgKvi9f48zNpqDJWqA
2M23sSfRTfQWghKNZ8plCe7oqEWgCgYIKoZIzj0DAQehRANCAAS9c/u+zDzdyIz2
MTOiS7uuAhTEADJn1twLuo0M7LwqHq4bt539N8ZMtZP2vOytBREyT4tx2pX7UBWh
tW4wg9Fh"