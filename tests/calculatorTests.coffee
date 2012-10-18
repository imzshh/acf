async = require 'async'
j3 = require 'j3'
app = require './app'

Calculator = require '../src/calculator'
AssignmentManager = require '../src/assignmentManager'
ResourceManager = require '../src/resourceManager'
Store = require '../src/store'

store = new Store
  dbConnStr : app.settings.dbConnStr

assignmentManager = new AssignmentManager
  store : store

resourceManager = new ResourceManager

resourceManager.registerResource
  type : 1
  filters : [
    type : 1
    filtrate : (resource, accessorId, assignments) ->
      permission = 0
      effect = false

      for assignment in assignments
        if assignment.aseId.toString() is accessorId.toString()
          effect = true
          permission |= assignment.permVal

      {effect, permission}
  ]

calculator = new Calculator
  assignmentManager : assignmentManager
  resourceManager : resourceManager

describe 'Calculator', ->
  describe '.calculate(resource, accessorId, callback)', ->
    it 'output the permission of the assignment', (done) ->
      asrId = app.newObjectID()
      aseId1 = app.newObjectID()
      aseId2 = app.newObjectID()
      acsId = aseId1
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
        calculator.calculate resource, aseId1, (err, permission) ->
          if err then return callback err

          permission.should.equal 23
          callback()

      , (callback) ->
        calculator.calculate resource, aseId2, (err, permission) ->
          if err then return callback err

          permission.should.equal 32
          callback()

      , (callback) ->
        calculator.calculate resource, asrId, (err, permission) ->
          if err then return callback err

          permission.should.equal 0
          callback()
        
        ], (err) ->
          if err then throw err
          done()
