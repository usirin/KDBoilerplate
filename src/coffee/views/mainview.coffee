class MainView extends KDView
  constructor: (options = {}, data) ->
    options.cssClass = 'main-view'
    options.tagName  = 'main'

    super options, data

    @appendToDomBody()

    @view = new KDView
      partial : 'Hello world!'

  viewAppended: ->
    @addSubView @view

