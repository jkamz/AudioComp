module AudioComp
  # Contains fingerprints and provides a method to compare them against other fingerprints.
  class Fingerprint
    # Number of bits in one item of raw fingerprint
    BITS_IN_RAW_FP = 32

    # Access (read) compressed fingerprints
    attr_reader :compressed

    # Access (read) raw fingerprints
    attr_reader :raw

    # Class initializer

    def initialize(compressed, raw)
      @compressed = compressed
      @raw = raw
    end

    # Compare two fingerprints
    # Takes in fingerprint to compare with and returns a float in 0..1 range where 1 is 100% match
    def compare (fingerprint)
      maximum_raw_size = [@raw.size, fingerprint.raw.size]
      bit_size = maximum_raw_size * BITS_IN_RAW_FP

      distance = hamming_distance(@raw, fingerprint.raw)

      1 - distance.to_f / bit_size
    end

    # Calculate hamming distance between 32 bit integer arrays
    # This simply calculates number of bits that are different

    def hamming_distance(arr1, arr2)
      distance = 0
      minimum_size, maximum_size = [arr1, arr2].map(&:size).sort

      minimum_size.times do |i|
        distance += (arr1[i] ^ arr2[i]).to_s(2).count('1')
      end

      distance += (maximum_size - minimum_size) * BITS_IN_RAW_FP
    end
    private :hamming_distance
  end
end
