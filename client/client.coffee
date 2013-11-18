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
    Meteor.call('clickClimber', @_id)
)
