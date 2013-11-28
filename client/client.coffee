Template.climbing.climbers = ->
  Climbers.find({}, {sort: {name: 1}})

Template.climber.htmlClass = ->
  "brother #{@name.toLowerCase()}"

Template.climber.bottomPosition = ->
  "#{@height-5}%"

Template.climber.imagePath = ->
  climber    = Climbers.findOne({ _id: @_id })
  isClimbing = climber.previous_height < climber.height
  name       = climber.name.toLowerCase()

  if isClimbing then "images/#{name}-climbing.gif" else "images/#{name}-falling.png"

Template.climber.events(
  'click': ->
    Meteor.call('clickClimber', @_id)
)
