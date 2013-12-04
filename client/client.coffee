Template.climbing.climbers = ->
  Climbers.find({}, {sort: {name: 1}})

Template.climber.lowercaseName = ->
  @name.toLowerCase()

Template.climber.htmlClass = ->
  "brother #{@name.toLowerCase()}"

Template.climber.bottomPosition = ->
  @base_bottom + @height

Template.climber.leftPosition = ->
  @base_left + (@height * 0.7 * @x_multipler)

Template.climber.imagePath = ->
  climber    = Climbers.findOne({ _id: @_id })
  isClimbing = climber.previous_height < climber.height
  isCheering = climber.summitted
  name       = climber.name.toLowerCase()

  postfix = switch
    when isClimbing then 'climbing.gif'
    when isCheering then 'cheering.gif'
    else                 'falling.png'

  "images/#{name}-#{postfix}"

Template.climber.clickPercentage = ->
  total = _.reduce(
    Climbers.find().fetch(), (sum, climber) ->
      sum + climber.clicks
    , 0
  )
  percentage = if total > 0 then @clicks / total else 0
  Math.round(percentage * 100)

Template.climber.rendered = ->
  canvas = $("#click-percentage-#{@data.name.toLowerCase()}")
  context = canvas.get(0).getContext("2d")

  data = [
    {
      value: canvas.data('percentage'),
      color: '#fab142'
    },
    {
      value: 100 - canvas.data('percentage'),
      color: '#ffffff'
    }
  ]

  writePercentage = ->
    context.font = '15pt Helvetica'
    context.fillStyle = '#fab142'
    context.fillText(canvas.data('percentage') + '%', 53, 77)

  new Chart(context).Doughnut(data, { animation: false, onAnimationComplete: writePercentage })

Template.climber.events(
  'click': ->
    Meteor.call('clickClimber', @_id)
)

Template.footer.rendered = ->
  $('.terminology-modal').leanModal();
