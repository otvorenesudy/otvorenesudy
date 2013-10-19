module OpenCourts
  module VERSION
    MAJOR = 1
    MINOR = 0
    TINY  = 8

    PRE = 'beta'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join '.'
  end
end
