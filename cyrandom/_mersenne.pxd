cdef extern from "_mersenne.h" nogil:
    # initializes mt[N] with a seed
    void init_genrand(unsigned long s)

    # generates a random number on [0,0xffffffff]-interval
    unsigned long genrand_int32()

    # generates a random number on [0,1]-real-interval
    double genrand_real1()

    # generates a random number on [0,1)-real-interval
    double genrand_real2()

    # generates a random number on (0,1)-real-interval
    double genrand_real3()

    # generates a random number on [0,1) with 53-bit resolution
    double genrand_res53()
