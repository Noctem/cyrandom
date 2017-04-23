cpdef double random() nogil

cdef unsigned short bit_length(unsigned long n) nogil

cdef unsigned long getrandbits(unsigned short k) nogil

cpdef long randrange(long start, long stop) nogil

cpdef long randint(long a, long b) nogil

cpdef double uniform(double a, double b) nogil

cpdef double triangular(double low=?, double high=?, double mode=?) nogil

cpdef long triangular_int(long low, long high, long mode) nogil
