module.exports = FormatterClang =
  config:
    executablePath:
      title: 'Path to the exectuable'
      type: 'string'
      default: 'clang-format'
    arguments:
      title: 'Arguments passed to the formatter'
      type: 'array'
      default: []

  provideFormatter: ->
    [
      {
        selector: '.source.c'
        getNewText: @format
      }
      {
        selector: '.source.cpp'
        getNewText: @format
      }
      {
        selector: '.source.objc'
        getNewText: @format
      }
    ]

  format: (text) ->
    child_process = require 'child_process'
    return new Promise (resolve, reject) ->
      command = atom.config.get 'formatter-clang-format.executablePath'
      args = atom.config.get 'formatter-clang-format.arguments'
      toReturn = []
      process = child_process.spawn(command, args, {})
      process.stdout.on 'data', (data) -> toReturn.push data
      process.stdin.write text
      process.stdin.end()
      process.on 'close', ->
        resolve(toReturn.join('\n'))
