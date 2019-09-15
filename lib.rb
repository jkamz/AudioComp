module AudioComp
  #Port Chromaprint's API functions
  module Lib
    extend FFI::Library
    ffi_lib 'chromaprint'

    #get chromapring version
    attach_function :chromaprint_get_version, [], :string

    # Allocate and initialize the Chromaprint context
    # Takes in the version of the fingerprint algorithm and
    # returns a chromaprint context pointer
    attach_function :chromaprint_new, [:int], :pointer

    # Restart the computation of a fingerprint with a new audio stream
    # Takes in context pointer, sample rate, and number of channels
    # Returns 0 on error and 1 on success

    attach_function :chromaprint_start, [:pointer, :int, :int], :int

    # Deallocate a Chromaprint context
    # Takes in the context pointer

    attach_function :chromaprint_free, [:pointer], :void

    # Send audio data to the fingerprint calculator
    # Takes in context pointer, raw audio data, and size of data buffers (in samples)
    # Returns 0 on error and 1 on success

    attach_function :chromaprint_feed, [:pointer, :pointer, :int], :int

    # Process any remaining buffered audio data and calculate the fingerprint
    # Takes in context pointer and returns 0 on error and 1 on success

    attach_function :chromaprint_finish, [:pointer], :int

    # Return the calculated fingerprint as a compressed string
    # Takes in context pointer and the pointer where fingerprint arrary will be stored
    # Returns 0 on error and 1 on success

    attach_function :chromaprint_get_fingerprint, [:pointer, :pointer], :int

    # Return the calculated fingerprint as an array of 32-bit integers
    # Takes in context pointer, the pointer where fingerprint arrary will be stored,
    # and size (number of items in the returned raw fingerprint)
    # Returns 0 on error and 1 on success

    attach_function :chromaprint_get_raw_fingerprint, [:pointer, :pointer, :pointer], :int

    # Compress and optionally base64-encode a raw fingerprint
    # Takes in:
    # - pointer to an array of 32-bit integers representing the raw
    #        fingerprint to be encoded
    #  - size: number of items in the raw fingerprint
    #  - algorithm: Chromaprint algorithm version which was used to generate the
    #               raw fingerprint
    #  - encoded_fp: pointer to a pointer, where the encoded fingerprint will be
    #                stored
    #  - encoded_size: size of the encoded fingerprint in bytes
    #  - base64: Whether to return binary data or base64-encoded ASCII data. The
    #            compressed fingerprint will be encoded using base64 with the
    #            URL-safe scheme if this parameter to is set to 1 and. It will return
    #            binary data if it's 0.

    # Returns 0 on error and 1 on success

    attach_function :chromaprint_encode_fingerprint,
                    [:pointer, :int, :int, :pointer, :pointer, :int],
                    :int

    # Uncompress and optionally base64-decode an encoded fingerprint
    # Takes in:
    #  - encoded_fp: Pointer to an encoded fingerprint
    #  - encoded_size: Size of the encoded fingerprint in bytes
    #  - fp: Pointer to a pointer, where the decoded raw fingerprint (array
    #        of 32-bit integers) will be stored
    #  - size: Number of items in the returned raw fingerprint
    #  - algorithm: Chromaprint algorithm version which was used to generate the
    #               raw fingerprint
    #  - base64: Whether the encoded_fp parameter contains binary data or
    #            base64-encoded ASCII data. If 1, it will base64-decode the data
    #            before uncompressing the fingerprint.

    # Returns 0 on error and 1 on success

    attach_function :chromaprint_decode_fingerprint,
                    [:pointer, :int, :pointer, :pointer, :pointer, :int],
                    :int

    # Free memory allocated by any function from the Chromaprint API
    # Takes in the pointer to be deallocated

    attach_function :chromaprint_dealloc, [:pointer], :void
  end
end
