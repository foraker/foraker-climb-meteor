Climbers = new Meteor.Collection('climbers')

if (Meteor.isClient)
  Template.climbing.climbers = ->
    Climbers.find({}, {sort: {score: -1, name: 1}})

  Template.climber.clicks = ->
    Climbers.findOne({ _id: @_id }).clicks

  Template.climber.name = ->
    Climbers.findOne({ _id: @_id }).name

  Template.climber.htmlClass = ->
    "climber #{@name.toLowerCase()}"

  Template.climber.events(
    'click': ->
      Climbers.update({ _id: @_id }, { $inc: { clicks: 1 } })
  )

if (Meteor.isServer)
  Meteor.startup ->
    if Climbers.find().count() is 0
      Climbers.insert(name: 'Stirling', clicks: 0)
      Climbers.insert(name: 'Derek', clicks: 0)
