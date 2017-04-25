# distutils: language = c
# cython: language_level=3

from libc.math cimport sqrt
from libc.stdint cimport int32_t, uint16_t, uint32_t

from cpython.mem cimport PyMem_Malloc, PyMem_Free

from ._seed cimport random_seed
from ._mersenne cimport genrand_int32, genrand_res53


random_seed()


cpdef double random() nogil:
    """Return a double between 0.0 and 1.0
    """
    return genrand_res53()


cdef uint16_t bit_length(uint32_t n) nogil:
    cdef uint16_t length = 0
    while n != 0:
        length += 1
        n >>= 1
    return length


cdef uint32_t getrandbits(uint16_t k) nogil:
    return genrand_int32() >> (32 - k)


cpdef int32_t randrange(int32_t start, int32_t stop, uint32_t step=1) nogil:
    """Choose a random item from range(start, stop).

    This fixes the problem with randint() which includes the
    endpoint; in Python this is usually not what you want.
    """
    cdef uint32_t width = stop - start
    if step == 1:
        return start + _randbelow(width)

    cdef uint32_t n

    if step > 0:
        n = (width + step - 1) // step
    else:
        n = (width + step + 1) // step

    return start + _randbelow(n)


cpdef int32_t randint(int32_t a, int32_t b) nogil:
    """Return random integer in range [a, b], including both end points.
    """
    cdef uint32_t width = b - a + 1
    return a + _randbelow(width)


cdef uint32_t _randbelow(uint32_t n) nogil:
    """Return a random int in the range [0,n).  Raises ValueError if n==0.
    """
    _getrandbits = getrandbits
    cdef uint16_t k = bit_length(n)  # don't use (n-1) here because n can be 1
    cdef uint32_t r = _getrandbits(k)  # 0 <= r < 2**k
    while r >= n:
        r = _getrandbits(k)
    return r


def choice(seq):
    """Choose a random element from a non-empty sequence."""
    cdef uint32_t i = _randbelow(len(seq))
    return seq[i]


def shuffle(list seq):
    """Shuffle list x in place, and return None.
    """
    cdef uint32_t i, j
    randbelow = _randbelow
    for i in reversed(range(1, len(seq))):
        j = randbelow(i+1)
        seq[i], seq[j] = seq[j], seq[i]


def choices(population, tuple weights=None, *, tuple cum_weights=None, Py_ssize_t k=1):
    """Return a k sized list of population elements chosen with replacement.

    If the relative weights or cumulative weights are not specified,
    the selections are made with equal probability.

    """
    cdef Py_ssize_t i, total
    cdef uint16_t num_weights
    cdef uint16_t* _cum_weights
    cdef list output = []

    if cum_weights is None:
        if weights is None:
            total = len(population)
            for i in range(k):
                output[i] = population[int(genrand_res53() * total)]
            return output

        num_weights = len(weights)
        _cum_weights = <uint16_t*> PyMem_Malloc(num_weights * 2)
        total = 0
        for i in range(num_weights):
            total += weights[i]
            _cum_weights[i] = total
    else:
        num_weights = len(cum_weights)
        _cum_weights = <uint16_t*> PyMem_Malloc(num_weights * 2)
        for i in range(num_weights):
            _cum_weights[i] = cum_weights[i]
        total = _cum_weights[num_weights - 1]

    cdef uint16_t lo, mid, hi
    cdef double x
    for i in range(k):
        lo = 0
        hi = num_weights
        x = genrand_res53() * total
        while lo < hi:
            mid = (lo + hi) // 2
            if x < _cum_weights[mid]:
                hi = mid
            else:
                lo = mid + 1
        output.append(population[lo])

    PyMem_Free(_cum_weights)
    return output


def choose_weighted(tuple population, tuple cum_weights):
    """Return an item from population according to provided weights.
    """
    cdef uint16_t hi = len(population)

    if len(cum_weights) != hi:
        raise ValueError('The number of weights does not match the population')

    cdef uint32_t total = cum_weights[-1]
    cdef uint16_t lo, mid
    cdef double x
    lo = 0
    x = genrand_res53() * total
    while lo < hi:
        mid = (lo + hi) // 2
        if x < cum_weights[mid]:
            hi = mid
        else:
            lo = mid + 1
    return population[lo]


cpdef double uniform(double a, double b) nogil:
    """Get a random number in the range [a, b) or [a, b] depending on rounding.
    """
    return a + (b-a) * genrand_res53()


cpdef double triangular(double low=0.0, double high=1.0, double mode=0.5) nogil:
    """Triangular distribution.

    Continuous distribution bounded by given lower and upper limits,
    and having a given mode value in-between.

    http://en.wikipedia.org/wiki/Triangular_distribution
    """
    cdef double c, u = genrand_res53()
    c = (mode - low) / (high - low)
    if u > c:
        u = 1.0 - u
        c = 1.0 - c
        low, high = high, low
    return low + (high - low) * sqrt(u * c)


cpdef int32_t triangular_int(int32_t low, int32_t high, int32_t mode) nogil:
    cdef double c, u = genrand_res53()
    c = (mode - low) / (high - low)
    if u > c:
        u = 1.0 - u
        c = 1.0 - c
        low, high = high, low
    return <int32_t>(low + (high - low) * sqrt(u * c))
