async = require 'async'

class AssignmentManager
  constructor : (options) ->
    @_store = options.store

  # 设置资源的权限分配记录
  setAssignments : (resource, assignments, callback) ->
    @_store.setAssignments resource, assignments, callback

  # 获取资源的权限分配记录，包括继承的记录
  getAssignments : (resource, callback) ->
    @_store.getAssignments resource, callback

module.exports = AssignmentManager
