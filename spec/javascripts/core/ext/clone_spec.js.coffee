#= require core/ext/clone

describe 'Clone', ->
  it 'should clone date', ->
    date = new Date()

    expect(date == clone(date)).toBeFalsy()
    expect(date.getTime()).toEqual(clone(date).getTime())

  it 'should clone RegExp', ->
    regexp = /^(a|b)*$/gi

    expect(regexp == clone(regexp)).toBeFalsy()
    expect(clone(regexp).global?).toBeTruthy()
    expect(clone(regexp).ignoreCase?).toBeTruthy()

  it 'should clone object instance', ->
    instance = new Object
    cloned   = clone(instance)

    expect(instance == cloned).toBeFalsy()
    
    expect(instance[key] is cloned[key]).toBeFalsy for key in instance
