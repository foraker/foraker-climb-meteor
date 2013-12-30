GAME_OVER = true

Template.climbing.climbers = ->
  Climbers.find({}, {sort: {name: 1}})

Template.climbing.showWinner = ->
  GAME_OVER && !Session.get("play")

Template.climber.lowercaseName = ->
  @name.toLowerCase()

Template.climber.htmlClass = ->
  "brother #{@name.toLowerCase()}"

Template.climber.bottomPosition = ->
  @base_bottom + @height

Template.climber.leftPosition = ->
  # Hack to keep Derek on the mountain if window's not max width
  negative_offset = if @name == 'Derek' then (1190 - $('.main').width())/2 else 0
  @base_left + (@height * 0.7 * @x_multipler) - negative_offset

Template.climber.imagePath = ->
  climber    = Climbers.findOne({ _id: @_id })
  isClimbing = climber.previous_height < climber.height
  isCheering = climber.summitted
  isDown     = climber.height == 0
  name       = climber.name.toLowerCase()

  postfix = switch
    when isClimbing then 'climbing.gif'
    when isCheering then 'cheering.gif'
    when isDown     then 'down.gif'
    else                 'falling.png'

  "images/#{name}-#{postfix}"

Template.climber.events(
  'click': (e) ->
    Session.set('clicks', (Session.get('clicks') || 0) + 1)
    if Session.get('clicks') > 200
      alert 'You are clicking too fast. I apologize, but you need to wait a moment or two.'
    else
      Meteor.call('clickClimber', @_id) if e.x > 0 or e.clientX > 0
  'touchstart': ->
    Meteor.call('clickClimber', @_id)
)

Template.winner.events(
  'click a.play-more': (e) ->
    Session.set('play', true)
)

$ ->
  $('body').unicornblast(
    start : 'konamiCode'
  )

  setInterval(->
    Session.set('clicks', 0)
  ,
  30000)
