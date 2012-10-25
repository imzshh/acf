async = require 'async'

class Calculator
  constructor : (options) ->
    @_assignmentManager = options.assignmentManager
    @_resourceManager = options.resourceManager

  calculate : (resource, accessorId, callback) ->
    async.waterfall [ (callback) =>
      @_assignmentManager.getAssignmentsOfResource resource, callback

    , (assignments, callback) =>
      assignmentsGroupByAseTp = __groupAssignmentsByAssigneeType assignments
      filters = @_resourceManager.getFiltersOfResourceType resource.type

      __calculate resource, accessorId, assignmentsGroupByAseTp, filters, callback
    ], callback

  calculateBatch : (resources, accessorId, callback) ->
    results = []
    async.forEachSeries resources, (resource, callback) =>
      @calculate resource, accessorId, (err, calcResult) ->
        if err then return callback err
        results.push calcResult
        callback()

    , (err) ->
      callback err, results

module.exports = Calculator

__groupAssignmentsByAssigneeType = (assignments) ->
  groupedAssignments = {}

  for assignment in assignments
    assignmentsOfType = groupedAssignments[assignment.aseTp]
    if not assignmentsOfType
      groupedAssignments[assignment.aseTp] = assignmentsOfType = []
    assignmentsOfType.push assignment

  groupedAssignments

__calculate = (resource, accessorId, assignmentsGroupByAseTp, filters, callback) ->
  if not filters or filters.length is 0
    return callback null,
      type : resource.type
      id : resource.id
      perm : 0

  permission = 0
  lastFiltResult = null
  lastPriority = -1

  nextFilterIndex = 0
  filter = filters[nextFilterIndex]
  async.until ->
    not filter or (lastFiltResult and lastFiltResult.effect and lastPriority isnt filter.priority)

  , (callback) ->
    curFilter = filter

    lastPriority = filter.priority
    nextFilterIndex++
    if nextFilterIndex < filters.length
      filter = filters[nextFilterIndex]
    else
      filter = null

    assignments = assignmentsGroupByAseTp[curFilter.type]

    if not assignments or assignments.length is 0
      lastFiltResult =
        effect : false
        permission : 0
      return callback()

    curFilter.filtrate resource, accessorId, assignments, (err, filtResult) ->
      if err then return callback err

      lastFiltResult = filtResult
      permission |= filtResult.permission
      callback()

  , (err) ->
    if err then permission is 0
    callback err,
      type : resource.type
      id : resource.id
      perm : permission

