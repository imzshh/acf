Store = require './store'
AssignmentManager = require './assignmentManager'
Calculator = require './calculator'

class Acf
  constructor : (options) ->
    @_dbConnStr = options.dbConnStr

    @_store = new Store
      dbConnStr : @_dbConnStr

    @_assignmentManager = new AssignmentManager
      store : @_store

    @_resourceManager = new ResourceManager

    @_calculator = new Calculator
      assignmentManager : @_assignmentManager
      resourceManager : @_resourceManager

  # 计算访问者对资源的最终权限值
  calculate : (resource, accessorId, callback) ->
    @_calculator.calculate resource, accessorId, callback

  # 设置资源的权限分配记录
  setAssignments : (resource, assignments, callback) ->
    @_assignmentManager.setAssignments resource, assignments, callback

  # 删除资源的权限分配记录
  removeAssignments : (resource, assignments, callback) ->
    @_assignmentManager.removeAssignments resource, assignments, callback

  # 获取资源的权限分配记录，包括继承的记录
  getAssignments : (resource, callback) ->
    @_assignmentManager.getAssignments resource, callback

  # 注册一个资源
  registerResource : (options) ->
    @_resourceManager.registerResource options

module.exports = Acf
