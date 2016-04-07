Who: Zachary Johnson, Booker Lightman, Charles Davies, Jonathan Odom

Title: Bullet Hell Multiplayer Game (wip)

Vision Statement: A game that is both educational to develop and fun to play. 

Automated Tests: The tests we created are part of our main file, myfirstbanner.pde. Testing can be turned on by changing the boolean value "unittest" to true. The test we have simulates the keys being pressed and makes sure the ship moves in the appropriate way. It then prints out the results. Screenshot:

User Acceptance Tests:
- When user presses W, A, S or D the user sprite moves in the appropriate direction at an equal rate
  - Secondarily, this movement is restricted within bounds
- Targeting cursor moves with user mouse
  - Additionally, clicking shoots exactly one shot in the the direction of the user mouse
- Whenever a user, or NPC is hit the scoreboard must update the appropriate score by 1 point
  - When hit, sprites must flash momentarily as an indication of contact with a shot
- (Future) Multiple users can connect to the lobby

https://github.com/chda6313/SemesterProject/blob/master/unittests.png



