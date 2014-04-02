@no_mobile
Feature: Dragging movable blocks above unmovable blocks do not move the unmovable blocks

Background:
  Given I am on "http://learn.code.org/s/1/level/32?noautoplay=true"
  And I rotate to landscape
  And I wait to see "#x-close"
  And I press "x-close"

Scenario: Try to drag an unmovable block
  Given I click block "8"
  And block "8" is at a location "original"
  And I drag block "8" to offset "200, 200"
  Then block "8" is at location "original"

Scenario: Attach a movable block on top of an unmovable block
  And I drag block "1" to offset "300, 200"
  And I drag block "13" above block "8"
  Then block "8" is child of block "13"

Scenario: Drag a movable block off of the top of an unmovable block
  And I drag block "1" to offset "300, 200"
  And I drag block "13" above block "8"
  And I drag block "13" to offset "300, 300"
  Then block "8" is not child of block "13"

Scenario: Begin dragging movable block off of the top of an unmovable block
  Given I drag block "1" to offset "300, 200"
  And I drag block "13" above block "8"
  And I begin to drag block "13" to offset "100, 100"
  Then block "13" is in front of block "8"

Scenario: Drag a movable block into the middle of two unmovable blocks
  And I drag block "1" to offset "300, 200"
  And I drag block "13" above block "11"
  Then block "11" is child of block "13"
  Then block "13" is child of block "9"
  Then block "11" is not child of block "9"

Scenario: Drag a movable block out of the middle of two unmovable blocks
  And I drag block "1" to offset "300, 200"
  And I drag block "13" above block "11"
  And I drag block "13" to offset "300, 200"
  Then block "11" is not child of block "13"
  Then block "13" is not child of block "9"
  Then block "11" is child of block "9"

Scenario: Drag multiple movable blocks off of the top of an unmovable block
  And I drag block "1" to offset "300, 200"
  And I drag block "1" to offset "400, 200"
  And I drag block "13" above block "8"
  And I drag block "14" above block "8"
  Then block "8" is child of block "14"
  And I drag block "13" to offset "300, 300"
  Then block "8" is not child of block "14"
  Then block "14" is child of block "13"
