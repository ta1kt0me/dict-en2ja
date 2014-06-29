DictEn2jaView = require './dict-en2ja-view'

module.exports =
  dictEn2jaView: null

  activate: (state) ->
    @dictEn2jaView = new DictEn2jaView(state.dictEn2jaViewState)

  deactivate: ->
    @dictEn2jaView.destroy()

  serialize: ->
    dictEn2jaViewState: @dictEn2jaView.serialize()
