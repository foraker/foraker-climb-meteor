Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(name: 'Stirling', clicks: 0, height: 50, summit_count: 0, death_count: 0)
    Climbers.insert(name: 'Derek', clicks: 0, height: 50, summit_count: 0, death_count: 0)

  slide = Meteor.bindEnvironment ->
    Climbers.update({ height: { $gt: 0 } }, $inc: { height: -0.5 }, { multi: true })
    Climbers.update({ height: 0 }, $inc: { death_count: 1 }, { multi: true })
  , (e) ->
    console.log e
  setInterval(slide, 1000)
