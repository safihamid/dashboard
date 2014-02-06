Feature: Blocks can be dragged 

Background:
  Given I am on localhost:3000/s/1/level/6

Scenario: Connect two blocks from toolbox
  When I wait for 3 seconds
  And I inject simulation
  And I press "x-close"
  And I press "ok-button"
  And I drag block "1" to offset "300, 0"
  And I drag block "1" to block "4"
  And I wait for 1 seconds
  Then block "5" is child of block "4"

