Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(name: 'Stirling', clicks: 0, height: 50)
    Climbers.insert(name: 'Derek', clicks: 0, height: 50)

  slide = Meteor.bindEnvironment ->
    Climbers.update({ height: { $gt: 0 } }, $inc: { height: -0.5 }, { multi: true })
  , (e) ->
    console.log e
  setInterval(slide, 1000)
