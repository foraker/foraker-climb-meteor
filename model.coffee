@Climbers = new Meteor.Collection('climbers')

Meteor.methods(
  clickClimber: (_id) ->
    Climbers.update({ _id: _id }, { $inc: { clicks: 1 } })
)
