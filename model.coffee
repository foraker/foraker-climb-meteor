Climbers = new Meteor.Collection('climbers')
exports = this
exports.Climbers = Climbers

Meteor.methods(
  clickClimber: (_id) ->
    Climbers.update({ _id: _id }, { $inc: { clicks: 1 } })
)
