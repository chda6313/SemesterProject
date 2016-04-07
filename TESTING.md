Who: Zachary Johnson, Booker Lightman, Charles Davies, Jonathan Odom

Title: Bullet Hell Multiplayer Game (wip)

Vision Statement: A game that is both educational to develop and fun to play. 

Automated Tests: The tests we created are part of our main file, myfirstbanner.pde. Testing can be turned on by changing the boolean value "unittest" to true. The test we have simulates the keys being pressed and makes sure the ship moves in the appropriate way. It then prints out the results. Screenshot:

User Acceptance Tests:
(1) General Startup: User should have just opened the game site
- Open game website: User should see a start menu, with a Query. Two boxes will be presented corresponding to NPC numbers
- Click NPC number box: User should be moved to the game screen, where the corresponding number of NPC sprites are shown in addition to the player sprite
  : NPC sprites should also be moving in an aggressive manner towards the player

(2) Controls Check: User should be on the game screen with the circular sprites
- Press W: Player sprite moves upwards
- Press S: Player sprite moves downwards
- Press A: Player sprite moves left
- Press D: Player sprite moves right
- Move mouse: Player targeting line should follow user mouse
- Click on screen: Player sprite should fire a circular shot in the direction of the mouse/targeting line

(3) Score Check: User should be on the game screen with the circular sprites and AT LEAST ONE NPC
- Allow the NPC sprite to shoot the player: Scoreboard at bottom of game screen should add 1 to NPC score
  : additionally player sprite should quickly flash red
- Hit a NPC sprite with a shot: Scoreboard at bottom of game screen should add 1 to player score
  : NPC sprite should flash red
  - Secondarily IF THERE ARE 2 NPC SPRITES: hit the previously unhit sprite: again scoreboard should add 1 to player score
    : Again the NPC sprite should flash red

https://github.com/chda6313/SemesterProject/blob/master/unittests.png



