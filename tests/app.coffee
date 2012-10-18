settings = require './settings'
Db = require '../src/db'

exports.settings = settings

exports.db = db = Db.connect settings.dbConnStr

exports.getAssignmentsCollection = (type) ->
  Db.getAssignmentsCollection db, type

exports.newObjectID = ->
  db.ObjectID.createPk()

exports.newObjectIDArray = (length) ->
  for i in [0...length]
    db.ObjectID.createPk()
