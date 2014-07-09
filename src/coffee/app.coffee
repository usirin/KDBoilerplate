do ->

  WebFontConfig =
    google     :
      families : [ 'Open+Sans:400,300,700,600:latin' ]

  do ->
    wf = new KDCustomHTMLView
      tagName    : 'script'
      attributes :
        'src'    : '//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'
        'type'   : 'text/javascript'
        'async'  : 'true'

    firstScript = document.getElementsByTagName('script')[0]
    firstScript.parentNode.insertBefore wf.getElement(), firstScript


  KD.registerSingleton 'mainView', new MainViewController view : new MainView

  {mainView} = KD.singletons
