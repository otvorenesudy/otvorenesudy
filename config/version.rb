module OpenCourts
  module VERSION
    MAJOR = 1
    MINOR = 1
    PATCH = 5

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
