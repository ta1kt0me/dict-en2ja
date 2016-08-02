{ScrollView} = require 'atom-space-pen-views'

class DictEn2jaView extends ScrollView
  @content: ->
    @div class: 'dict-en2ja', =>
      @h1 class: 'dict-en2ja__word'
      @p class: 'dict-en2ja__meanings'

  constructor: ->
    super
    @elemWord = @find('.dict-en2ja__word')
    @elemMeanings = @find('.dict-en2ja__meanings')
    @title = 'dict-en2ja'

  getTitle: ->
    @title

  outputMeanings: (word, mean) =>
    @elemWord.empty()
    @elemMeanings.empty()
    @elemWord.append(word)
    @elemMeanings.append(@format(mean))

  format: (mean) ->
    mean.replace(/\t/g, "<br>")

module.exports = DictEn2jaView
