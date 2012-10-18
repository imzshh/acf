async = require 'async'
j3 = require 'j3'
app = require './app'

Store = require '../src/store'
store = new Store
  dbConnStr : app.settings.dbConnStr

describe 'Store', ->
  describe '.setAssignments(resource, assignments, callback)', ->
    it 'should save new assignments into datastore', (done) ->
      asrId = app.newObjectID()
      aseId1 = app.newObjectID()
      aseId2 = app.newObjectID()
      resource =
        id : app.newObjectID()
        type : 1
      assignments = [
        aseTp : 1
        aseId : aseId1
        asrId : asrId
        permLvl : 0
        permVal : 23
      ,
        aseTp : 1
        aseId : aseId2
        asrId : asrId
        permLvl : 0
        permVal : 32
      ]

      async.waterfall [ (callback) ->
        store.setAssignments resource, assignments, (err) ->
          callback err

      , (callback) ->
        collection = app.getAssignmentsCollection 1
        filter =
          resId : resource.id
        options =
          sort : _id : 1
        collection.findItems filter, options, (err, savedAssignments) ->
          if err then return callback err

          savedAssignments.length.should.equal assignments.length

          fieldsToCompare = ['permLvl', 'permVal']

          j3.equals(j3.clone(assignments[0], fieldsToCompare), j3.clone(savedAssignments[0], fieldsToCompare)).should.equal true
          j3.equals(j3.clone(assignments[1], fieldsToCompare), j3.clone(savedAssignments[1], fieldsToCompare)).should.equal true
          callback()

        ], (err) ->
          if err then throw err
          done()

    it 'should change exist assignments in datastore', (done) ->
      asrId = app.newObjectID()
      aseId1 = app.newObjectID()
      aseId2 = app.newObjectID()
      resource =
        id : app.newObjectID()
        type : 1
      assignments = [
        aseTp : 1
        aseId : aseId1
        asrId : asrId
        permLvl : 0
        permVal : 23
      ,
        aseTp : 1
        aseId : aseId2
        asrId : asrId
        permLvl : 0
        permVal : 32
      ]

      changedAssignments = [
        aseTp : 1
        aseId : aseId2
        asrId : asrId
        permLvl : 0
        permVal : 233
      ]

      async.waterfall [ (callback) ->
        store.setAssignments resource, assignments, (err) ->
          callback err

      , (callback) ->
        store.setAssignments resource, changedAssignments, (err) ->
          callback err

      , (callback) ->
        collection = app.getAssignmentsCollection 1
        filter =
          resId : resource.id
        options =
          sort : _id : 1
        collection.findItems filter, options, (err, savedAssignments) ->
          if err then return callback err

          savedAssignments.length.should.equal assignments.length

          fieldsToCompare = ['permLvl', 'permVal']
          j3.equals(j3.clone(assignments[0], fieldsToCompare), j3.clone(savedAssignments[0], fieldsToCompare)).should.equal true

          j3.equals(j3.clone(changedAssignments[0], fieldsToCompare), j3.clone(savedAssignments[1], fieldsToCompare)).should.equal true
          callback()

        ], (err) ->
          if err then throw err
          done()
