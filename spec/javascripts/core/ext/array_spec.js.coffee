#= require core/ext/array

describe 'Array', ->
  it 'should remove element from array', =>
    array = [1,2,3]

    array.remove(1)

    expect(1 in array).toBeFalsy()
