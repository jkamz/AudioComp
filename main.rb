require 'ffi'

require_relative 'lib'
require_relative 'app'
require_relative 'fprints'

module AudioComp
  # Algorithm constants as taken from chromaprint.h
  ALGORITHM_TEST1 = 0
  ALGORITHM_TEST2 = 1
  ALGORITHM_TEST3 = 2

  ALGORITHM_DEFAULT = ALGORITHM_TEST2

  BYTES_PER_SAMPLE = 2  #Since chromaprint works with 16 bit samples

  # Chromaprint library version

  def self.version
    Lib.chromaprint_get_version
  end
end
