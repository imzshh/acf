async = require 'async'

class AssignmentManager
  constructor : (options) ->
    @_store = options.store

  # 设置资源的权限分配记录
  setAssignmentsOfResource : (resource, assignments, callback) ->
    @_store.setAssignmentsOfResource resource, assignments, callback

  # 删除资源的权限分配记录
  removeAssignmentsOfResource : (resource, assignments, callback) ->
    @_store.removeAssignmentsOfResource resource, assignments, callback

  # 获取资源的权限分配记录，包括继承的记录
  getAssignmentsOfResource : (resource, callback) ->
    @_store.getAssignmentsOfResource resource, callback

  # 获取受让人对某一类资源的权限分配记录
  getAssignmentsOfAssignee : (assignee, resourceType, callback) ->
    @_store.getAssignmentsOfAssignee assignee, resourceType, callback

module.exports = AssignmentManager
