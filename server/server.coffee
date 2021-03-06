SLIDE_INCREMENT = 0.5

Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(
      name: 'Stirling',
      clicks: 0,
      previous_height: 49,
      height: 0,
      summit_count: 0,
      death_count: 0,
      charity_name: "Angel Flight West",
      charity_url: "http://www.angelflightwest.org/",
      base_bottom: -30,
      base_left: 230,
      x_multipler: -1, # move left,
      summitted: false,
      resetting: false
    )
    Climbers.insert(
      name: 'Derek',
      clicks: 0,
      previous_height: 49,
      height: 0,
      summit_count: 0,
      death_count: 0,
      charity_name: "Alaska Center for the Environment",
      charity_url: "http://akcenter.org/",
      base_bottom: -30,
      base_left: 171,
      x_multipler: 1, # move right
      summitted: false,
      resetting: false
    )

  slide = Meteor.bindEnvironment ->
    # Increment death if about to die
    Climbers.update({ height: SLIDE_INCREMENT, resetting: false }, $inc: { death_count: 1 }, { multi: true })
    # Keep track of previous height
    Meteor.call('recordPreviousHeights')
    # Slide each climber down
    Climbers.update(
      { height: { $gt: 0 } },
      $inc: { height: -SLIDE_INCREMENT },
      { multi: true }
    )
    Climbers.update(
      { resetting: true, height: { $gt: 0 } },
      $inc: { height: -50 },
      { multi: true }
    )
    Climbers.update({ height: { $lt: 0 } }, $set: { height: 0 }, { multi: true })
    Climbers.update({}, $set: { summitted: false, resetting: false }, { multi: true }) if Climbers.find({ height: 0 }).fetch().length == 2
  , (e) ->
    console.log e
  setInterval(slide, 1000)
