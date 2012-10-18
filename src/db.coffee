mongo = require 'mongoskin'

exports.connect = (connectionString) ->
  db = mongo.db connectionString
  db

exports.getAssignmentsCollection = (db, resourceType) ->
  collectionName = 'acfAssignments_' + resourceType

  collection = db[collectionName]
  if not collection
    db.bind collectionName
    collection = db[collectionName]
    collection.ensureIndex resId : 1

  collection

