_coffeeScriptFiles = [
  'acf'
  'db'
  'store'
  'assignmentManager'
  'resourceManager'
  'calculator'
]

module.exports =
  name : 'acf'
  main : 'build-acf'
  steps :
    'build-acf' :
      type : 'compile-coffee'
      writeFile : true
      files : _coffeeScriptFiles
      inputPath : './src'
      outputPath : './lib'

