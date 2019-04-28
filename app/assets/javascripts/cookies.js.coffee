window.addEventListener 'load', ->
  window.cookieconsent.initialise
    palette:
      popup:
        background: '#8392ac'
        text: '#fff'
    content:
      message: 'Táto stránka využíva cookies. V prípade, že nesúhlasíte s ukladaním súborov cookies na Vašom zariadení, opustite túto stránku.'
      dismiss: 'Súhlasím'
    showLink: false
