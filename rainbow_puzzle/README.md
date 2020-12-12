# Rainbow Puzzle

### Overview

_main.dart_: app initialization and top-level UI widget rendering
_board.dart_: gesture detection and game board rendering
_piece.dart_: game piece model / rendering / animations
_controller.dart_: process turns / update board / other game logic
_score.dart_: track score and refresh view when score is changed
_start_button.dart_: updates start button text depending on game state

## Gameplay

![](https://github.com/einoorish/FlutterGames/blob/master/rainbow_puzzle/gameplay.gif)

1. The game board renders the game pieces based on their current x/y positions on the board.
2. When a *swipe gesture* is detected, a turn is taken.
3. After taking a turn the board is evaluated to determine where to move pieces and when to combine them.

The **controller** handles board calculations and will refresh the board upon each turn, updating the score as required.

- Each game piece has an x/y position on the board, along with a value from 0 to 6 corresponding to each of the seven colors in the visible spectrum.
- When a game piece is moved, it will animate itself to the new position on the board. When a piece collides with one of the same value, the target piece is removed, then the moving piece is promoted and moved to the target location.
- If two pieces of highest possible value(purple) collide(merge) they are both removed and a bonus score is awarded
- At each turn new piece appears at random position.

**Win condition**: Merged all pieces
**Game over condition**: No place for new piece left

#### Main widget structure:

```sh
MaterialApp
    home: Scaffold
        body: Column
            children:
                ScoreView(),
                GameBoard(),
                StartButtonView()
```

#### ScoreView and StartButtonView
Both are implemented with a separate model and view, with the model extending *ChangeNotifier* and the view consuming this model, which will allow the view to automatically update when the model is changed.
This is accomplished by calling *notifyListeners()* within the model value setter, which will propagate the notification to *ChangeNotifierProvider*, causing the widget to rebuild itself with the new score value.

This illustrates a basic implementation of [state management with provider][doc] and provides a clean way to update a view when the model changes state.

#### GamePiece
 When the piece is moved to a new position, the *ChangeNotifierProvider* within GamePiece picks up the change, rebuilding the widget and firing off the controller that drives the animation of moving the widget across the screen.

  The animation is driven by an *AnimationController* on the game piece state, using *TickerProviderStateMixin* to synchronize itself with the animation controller.

  The constructor for GamePieceView creates animated values for x and y using *Tween* and *CurvedAnimation*, which will create an animation path from previous to current position.

#### GameBoard

```sh
Board:
    GestureDetector
        Container
              Stack
                children: pieces
```

*GestureDetector* captures and averages DragUpdateDetails and DragEndDetails, then submits the result to Controller.
*StreamSubscription*'s event listener is set up to receive update events from the Controller to re-draw the UI after each turn (on swipe end)

### Dependencies
| Dependency | Usage |
| ------ | ------ |
| cupertino_icons | default set of icon assets used by Cupertino widgets |
| provider | state management |
| oktoast | to show "game over" text without passing the context |
| flutter_launcher_icons | to replace launcher icon |


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen.)

   [doc]: <https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple>