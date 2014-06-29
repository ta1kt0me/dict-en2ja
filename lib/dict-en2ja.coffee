DictEn2jaView = require './dict-en2ja-view'

module.exports =
  dictEn2jaView: null

  activate: (state) ->
    # @dictEn2jaView = new DictEn2jaView(state.dictEn2jaViewState)
    atom.workspaceView.command "dict-en2jp:search", => @search()

  deactivate: ->
    @dictEn2jaView.destroy()

  serialize: ->
    dictEn2jaViewState: @dictEn2jaView.serialize()

  search: ->
    console.log("exec search")
