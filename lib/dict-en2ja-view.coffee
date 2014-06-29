{View} = require 'atom'

module.exports =
class DictEn2jaView extends View
  @content: ->
    @div class: 'dict-en2ja overlay from-top', =>
      @div "The DictEn2ja package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "dict-en2ja:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "DictEn2jaView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
