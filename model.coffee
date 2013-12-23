@Climbers = new Meteor.Collection('climbers')
MAX_HEIGHT = 500

Meteor.methods(
  clickClimber: (_id) ->
    climber = Climbers.findOne({ _id: _id })
    unless climber.resetting
      Meteor.call('recordPreviousHeights')
      Climbers.update({ _id: _id }, { $inc: { clicks: 1 } })
      Climbers.update({ _id: _id, height: { $lt: MAX_HEIGHT } }, { $inc: { height: 4 } })
      Meteor.call('handleSummit') if Climbers.find({ height: MAX_HEIGHT }).fetch().length > 0
  ,
  recordPreviousHeights: ->
    Climbers.find({}).forEach (climber) ->
      Climbers.update({_id: climber._id}, $set: { previous_height: climber.height } )
  ,
  handleSummit: ->
    Climbers.update({ height: { $gte: MAX_HEIGHT }, summitted: false }, { $inc: { summit_count: 1 }, $set: { summitted: true } }, { multi: true })
    Climbers.update({}, $set: { resetting: true }, { multi: true })
)
