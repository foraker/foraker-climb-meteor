@Climbers = new Meteor.Collection('climbers')

Meteor.methods(
  clickClimber: (_id) ->
    Climbers.update({ _id: _id }, { $inc: { clicks: 1 } })
    Climbers.update({ _id: _id, height: { $lt: 100 } }, { $inc: { height: 1 } })
    Climbers.update({ _id: _id, height: 100 }, { $inc: { summit_count: 1 } })
)
