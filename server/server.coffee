SLIDE_INCREMENT = 0.5

Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(
      name: 'Stirling',
      clicks: 0,
      previous_height: 49,
      height: 50,
      summit_count: 0,
      death_count: 0,
      charity: "Environment +",
      base_bottom: -30,
      base_left: 240,
      x_multipler: -1 # move left
    )
    Climbers.insert(
      name: 'Derek',
      clicks: 0,
      previous_height: 49,
      height: 50,
      summit_count: 0,
      death_count: 0,
      charity: "Children's Hospital",
      base_bottom: -30,
      base_left: 161,
      x_multipler: 1 # move right
    )

  slide = Meteor.bindEnvironment ->
    # Increment death if about to die
    Climbers.update({ height: SLIDE_INCREMENT }, $inc: { death_count: 1 }, { multi: true })
    # Keep track of previous height
    Meteor.call('recordPreviousHeights')
    # Slide each climber down
    Climbers.update({ height: { $gt: 0 } }, $inc: { height: -SLIDE_INCREMENT }, { multi: true })
  , (e) ->
    console.log e
  setInterval(slide, 1000)
