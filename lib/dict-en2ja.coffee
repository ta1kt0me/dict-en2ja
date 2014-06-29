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
    word = atom.workspace.activePaneItem.getSelection().getText()
    console.log("exec search : " + word)

    http = require 'http'
    urlParam = "/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=#{word}&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=JSON&PageSize=1&PageIndex=0"
    http.get {
      hostname : 'public.dejizo.jp',
      path : urlParam
    }, (res) ->
      console.log(res)
      res.setEncoding('utf8')

      itemId = ""
      content = ""
      res.on 'data', (chunk) ->
        content += chunk
      res.on 'end', ->
        {parseString} = require 'xml2js'
        parseString content, (err, result) ->
          console.dir result
          itemId = result.SearchDicItemResult.TitleList[0].DicItemTitle[0].ItemID[0]
          console.log(itemId)
        # console.log(content)
