Clicks = new Meteor.Collection('clicks')

if (Meteor.isClient)
  Template.hello.greeting = ->
    return "Welcome to foraker-climb-meteor.";

  Template.hello.stirlingClicks = ->
    Clicks.findOne({ person: 'Stirling' })?.clicks || 0

  Template.hello.derekClicks = ->
    Clicks.findOne({ person: 'Derek' })?.clicks || 0

  Template.hello.events(
    'click div' : (e) ->
      console.log "#{e.x} < #{($('body').width() / 2)}"
      if e.x < ($('body').width / 2)
        Clicks.update({_id:Clicks.findOne({person: 'Stirling'})['_id']}, { $inc: { clicks: 1 } })
      else
        Clicks.update({_id:Clicks.findOne({person: 'Derek'})['_id']}, { $inc: { clicks: 1 } })
  )

if (Meteor.isServer)
  Meteor.startup ->
    Clicks.insert(person: 'Stirling', clicks: 0)
    Clicks.insert(person: 'Derek', clicks: 0)
