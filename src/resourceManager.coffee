async = require 'async'

class ResourceManager
  constructor : ->
    @_resourceTypes = {}

  registerResource : (options) ->
    @_resourceTypes[options.type] = options

  getFiltersOfResourceType : (resourceType) ->
    options = @_resourceTypes[resourceType]
    if not options then return []

    return options.filters || []

module.exports = ResourceManager
