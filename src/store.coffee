async = require 'async'
j3 = require 'j3'
db = require './db'

class Store
  constructor : (options) ->
    @_dbConnStr = options.dbConnStr
    @_db = db.connect @_dbConnStr

  getAssignments : (resource, callback) ->
    collection = db.getAssignmentsCollection @_db, resource.type
    filter =
      resId : resource.id
    collection.findItems filter, (err, assignments) ->
      if err then return callback err
      callback null, assignments

  setAssignments : (resource, assignments, callback) ->
    collection = db.getAssignmentsCollection @_db, resource.type
    async.forEachSeries assignments, (assignment, callback) ->
      assignment.resId = resource.id
      filter =
        resId : assignment.resId
        aseTp : assignment.aseTp
        aseId : assignment.aseId
      collection.findOne filter, (err, assignmentInDb) ->
        if err then return callback err

        if assignmentInDb
          updateData = $set : j3.clone(assignment, ['permLvl', 'permVal', 'subPerm'], true)
          collection.update {_id:assignmentInDb._id}, updateData, (err) ->
            callback err
        else
          collection.insert assignment, (err) ->
            callback err

        return

    , callback

    return

  removeAssignments : (resource, assignments, callback) ->
    collection = db.getAssignmentsCollection @_db, resource.type
    async.forEachSeries assignments, (assignment, callback) ->
      filter =
        resId : resource.id
        aseTp : assignment.aseTp
        aseId : assignment.aseId
      collection.remove filter, (err) ->
        if err then return callback err
        callback()

    , callback

module.exports = Store
