@Climbers = new Meteor.Collection('climbers')
MAX_HEIGHT = 500

Meteor.methods(
  clickClimber: (_id) ->
    Meteor.call('recordPreviousHeights')
    Climbers.update({ _id: _id }, { $inc: { clicks: 1 } })
    Climbers.update({ _id: _id, height: { $lt: MAX_HEIGHT } }, { $inc: { height: 1 } })
    Climbers.update({ _id: _id, height: MAX_HEIGHT }, { $inc: { summit_count: 1 } })
  ,
  recordPreviousHeights: ->
    Climbers.find({}).forEach (climber) ->
      Climbers.update({_id: climber._id}, $set: { previous_height: climber.height } )
)
