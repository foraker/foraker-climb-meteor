Meteor.startup ->
  if Climbers.find().count() is 0
    Climbers.insert(name: 'Stirling', clicks: 0)
    Climbers.insert(name: 'Derek', clicks: 0)
