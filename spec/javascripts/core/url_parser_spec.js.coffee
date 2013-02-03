#= require namespace
#= require core/url_parser

describe 'UrlParser', ->
  beforeEach =>
    @parser = UrlParser
  
  it 'should validate url', =>
    url = 'title:foo&genres:plala,pla+pla'

    expect(@parser.validate(url)).toBeTruthy()

  it 'should fail while validating url', =>
    url = 'blabla&&'

    expect(@parser.validate(url)).toBeFalsy()

  it 'should parse array of parameters', =>
    url = 'title:bad&genres:bla,bla,tralala&er:1'

    result = @parser.parse(url)

    expect(result.title).toEqual(['bad'])
    expect(result.genres).toEqual(['bla','bla','tralala'])
    expect(result.er).toEqual(['1'])
