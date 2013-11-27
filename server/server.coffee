SLIDE_INCREMENT = 0.5

Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(name: 'Stirling', clicks: 0, previous_height: 49, height: 50, summit_count: 0, death_count: 0)
    Climbers.insert(name: 'Derek', clicks: 0, previous_height: 49, height: 50, summit_count: 0, death_count: 0)

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
