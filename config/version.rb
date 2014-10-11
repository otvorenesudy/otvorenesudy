module OpenCourts
  module VERSION
    MAJOR = 1
    MINOR = 1
    PATCH = 0

    PRE = 'alpha'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
