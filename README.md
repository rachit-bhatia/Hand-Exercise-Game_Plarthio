# Hand Exercise Game App [Plarthio]
An iOS/iPadOS Swift Playgrounds app that gamifies hand exercises meant to alleviate discomfort due to hand arthritis. The app consists of 2 different minigames, both of which function based on a particular set of hand poses. The hand movements caused from swiftly shifting between the hand poses serve as joint-loosening exercises. 

- SwiftUI has been used to make the UI of the entire application
- A live camera feed has been setup using AVFoundation to capture user inputs
- SpriteKit's game engine powers the game logic
- Core ML hand pose classifier models were trained using Create ML and incorporated into the app to detect the hand poses. The models have been trained to detect 4 different hand poses. Since Create ML only accepts a maximum of 4000 images for the hand pose classifier, the quantity of the training datasets had to be limited. In order to reduce the training data within the limit without compromising model accuracy, 2 different models were trained with each model limited to 2 hand poses.

## Games within the app:
### 1. Color Catch - Catch the coloured coin into the correct palette hole
<img src="https://github.com/rachit-bhatia/Hand-Exercise-Game_Plarthio/blob/main/SS_imgs/Color%20Catch.jpg" width="300" height="400"/> 

### 2. Dodge Obs - Dodge all the obstacles in the way and keep the mover running
<img src="https://github.com/rachit-bhatia/Hand-Exercise-Game_Plarthio/blob/main/SS_imgs/Dodge%20Obs.jpg" width="300" height="400"/> 
