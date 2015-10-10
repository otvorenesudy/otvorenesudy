module OpenCourts
  module VERSION
    MAJOR = 1
    MINOR = 4
    PATCH = 2

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
