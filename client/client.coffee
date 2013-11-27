Template.climbing.climbers = ->
  Climbers.find({}, {sort: {name: 1}})

Template.climber.clicks = ->
  Climbers.findOne({ _id: @_id }).clicks

Template.climber.summits = ->
  Climbers.findOne({ _id: @_id }).summit_count

Template.climber.deaths = ->
  Climbers.findOne({ _id: @_id }).death_count

Template.climber.name = ->
  Climbers.findOne({ _id: @_id }).name

Template.climber.height = ->
  Climbers.findOne({ _id: @_id }).height

Template.climber.charity = ->
  Climbers.findOne({ _id: @_id }).charity

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
