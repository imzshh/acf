async = require 'async'

class Calculator
  constructor : (options) ->
    @_assignmentManager = options.assignmentManager
    @_resourceManager = options.resourceManager

  calculate : (resource, accessorId, callback) ->
    async.waterfall [ (callback) =>
      @_assignmentManager.getAssignments resource, callback

    , (assignments, callback) =>
      assignmentsGroupByAseTp = __groupAssignmentsByAssigneeType assignments
      filters = @_resourceManager.getFiltersOfResourceType resource.type

      permission = __calculate resource, accessorId, assignmentsGroupByAseTp, filters
      callback null, permission
    ], callback

module.exports = Calculator

__groupAssignmentsByAssigneeType = (assignments) ->
  groupedAssignments = {}

  for assignment in assignments
    assignmentsOfType = groupedAssignments[assignment.aseTp]
    if not assignmentsOfType
      groupedAssignments[assignment.aseTp] = assignmentsOfType = []
    assignmentsOfType.push assignment

  groupedAssignments

__calculate = (resource, accessorId, assignmentsGroupByAseTp, filters) ->
  permission = 0
  lastFiltResult = null
  lastPriority = -1

  for filter in filters
    if lastFiltResult and lastFiltResult.effect and lastPriority isnt filter.priority
      return permission

    lastPriority = filter.priority

    assignments = assignmentsGroupByAseTp[filter.type]
    if assignments and assignments.length
      lastFiltResult = filter.filtrate resource, accessorId, assignments
    else
      lastFiltResult =
        effect : false
        permission : 0
    permission |= lastFiltResult.permission

  permission

