WordEn = require './word-En'
DictEn2jaView = require './dict-en2ja-view'
{CompositeDisposable} = require 'atom'
url = require 'url'
pluralize = require 'pluralize'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable()
    @subscriptions.add atom.commands.add('atom-workspace', 'dict-en2ja:mean': =>
      @mean()
    )

    atom.workspace.addOpener (uriToOpen) ->
      { protocol, pathname } = url.parse(uriToOpen)
      return unless protocol is 'dict-en2ja:'
      new DictEn2jaView()

  deactivate: ->

  mean: ->
    editor = atom.workspace.getActivePaneItem()
    word = editor.getSelectedText()
    word = editor.getWordUnderCursor() if word is ''
    wordEn = new WordEn(pluralize.singular(word))
    wordEn.getItemMean().then (mean) ->
      uri = "dict-en2ja://#{wordEn}"
      atom.workspace.open(uri, split: 'down', activatePane: false)
      .done (dictEn2jaView) ->
        if dictEn2jaView instanceof DictEn2jaView
          dictEn2jaView.outputMeanings(wordEn.word, mean)
