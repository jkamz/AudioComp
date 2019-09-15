module AudioComp
  # Calculates fingerprints of audio data
  class App
    # initialize class
    # Takes in sample rate, no. of channels, and preferred fingerprinting algorithm

    def initialize(rate, channels, algorithm = ALGORITHM_DEFAULT)
      @rate = rate
      @no_of_channels = channels
      @algorithm = algorithm
    end

    # Calculate raw and compressed fingerprints of  the audio data
    # Takes in a string of raw audio data preseted by 16-bit signed integers and returns
    # a fingerpring instance (AudioComp::Fingerprint)

    def get_fingerprint(audio_data)
      # Allocate memory for app instance and initialize
      # chromaprint_new returns a chromprint pointer of current context
      # chromaprint_start computes a fingerprint of an audio stream
      context_pointer = Lib.chromaprint_new(@algorithm)
      Lib.chromaprint_start(context_pointer, @rate, @no_of_channels)

      #create pointer to audio data
      data_pointer = FFI::MemoryPointer.from_string(audio_data)

      # Calculate no of samples then feed the audio data

      data_size = data_pointer.size / BYTES_PER_SAMPLE

      # chromaprint_feed sends audio data to the fingerprint calculator
      Lib.chromaprint_feed(context_pointer, data_pointer, data_size)

      #Calculate fingerprint
      Lib.chromaprint_finish(context_pointer)

      # Compressed fingerprints
      fingerprint_pointer_pointer = FFI::MemoryPointer.new(:pointer)
      Lib.chromaprint_get_fingerprint(context_pointer, fingerprint_pointer_pointer)

      fingerprint_pointer = fingerprint_pointer_pointer.get_pointer(0)
      fingerprint = fingerprint_pointer.get_string(0)

      # Raw fingerprint
      raw_fingerprint_pointer_pointer = FFI::MemoryPointer.new(:pointer)
      size_pointer = FFI::MemoryPointer.new(:pointer)
      Lib.chromaprint_get_raw_fingerprint(context_pointer,
                                          raw_fingerprint_pointer_pointer,
                                          size_pointer)

      raw_fingerprint_pointer = raw_fingerprint_pointer_pointer.get_pointer(0)
      raw_fingerprint = raw_fingerprint_pointer.get_array_of_uint(0, size_pointer.get_int32(0))

      Fingerprint.new(fingerprint, raw_fingerprint)

    ensure
      # Free allocated mem
      Lib.chromaprint_free(context_pointer)             if context_pointer
      Lib.chromaprint_dealloc(fingerprint_pointer)      if fingerprint_pointer
      Lib.chromaprint_dealloc(raw_fingerprint_pointer)  if raw_fingerprint_pointer
    end
  end
end
