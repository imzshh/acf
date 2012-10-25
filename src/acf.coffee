Store = require './store'
AssignmentManager = require './assignmentManager'
ResourceManager = require './resourceManager'
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

  # 批量计算访问者对资源的最终权限值
  calculateBatch : (resources, accessorId, callback) ->
    @_calculator.calculateBatch resources, accessorId, callback

  # 设置资源的权限分配记录
  setAssignmentsOfResource : (resource, assignments, callback) ->
    @_assignmentManager.setAssignmentsOfResource resource, assignments, callback

  # 删除资源的权限分配记录
  removeAssignmentsOfResource : (resource, assignments, callback) ->
    @_assignmentManager.removeAssignmentsOfResource resource, assignments, callback

  # 获取资源的权限分配记录，包括继承的记录
  getAssignmentsOfResource : (resource, callback) ->
    @_assignmentManager.getAssignmentsOfResource resource, callback

  # 获取受让人对某一类资源的权限分配记录
  getAssignmentsOfAssignee : (assignee, resourceType, callback) ->
    @_assignmentManager.getAssignmentsOfAssignee assignee, resourceType, callback

  # 注册一个资源
  registerResource : (options) ->
    @_resourceManager.registerResource options

module.exports = Acf
