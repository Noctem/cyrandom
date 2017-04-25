from libc.stdint cimport int32_t, uint16_t, uint32_t, uint64_t

cpdef double random() nogil

cdef uint16_t bit_length(uint32_t n) nogil

cdef uint32_t getrandbits(uint16_t k) nogil

cpdef int32_t randrange(int32_t start, int32_t stop, uint32_t step=?) nogil

cpdef int32_t randint(int32_t a, int32_t b) nogil

cpdef double uniform(double a, double b) nogil

cpdef double triangular(double low=?, double high=?, double mode=?) nogil

cpdef int32_t triangular_int(int32_t low, int32_t high, int32_t mode) nogil
