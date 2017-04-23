# distutils: language = c
# cython: language_level=3

from libc.math cimport sqrt

from bisect import bisect as _bisect
from itertools import accumulate as _accumulate

from ._seed cimport random_seed
from ._mersenne cimport genrand_int32, genrand_res53


random_seed()


cpdef double random():
    """Return a double between 0.0 and 1.0
    """
    return genrand_res53()


cdef unsigned short bit_length(unsigned long n):
    cdef unsigned short length = 0
    while n != 0:
        length += 1
        n >>= 1
    return length


cdef unsigned long getrandbits(unsigned short k):
    return genrand_int32() >> (32 - k)


cpdef long randrange(long start, long stop):
    """Choose a random item from range(start, stop).

    This fixes the problem with randint() which includes the
    endpoint; in Python this is usually not what you want.
    """
    cdef unsigned long width = stop - start
    return start + _randbelow(width)


cpdef long randint(long a, long b):
    """Return random integer in range [a, b], including both end points.
    """
    return randrange(a, b+1)


cdef unsigned long _randbelow(unsigned long n):
    """Return a random int in the range [0,n).  Raises ValueError if n==0.
    """
    _getrandbits = getrandbits
    cdef unsigned short k = bit_length(n)  # don't use (n-1) here because n can be 1
    cdef unsigned long r = _getrandbits(k)  # 0 <= r < 2**k
    while r >= n:
        r = _getrandbits(k)
    return r


def choice(seq):
    """Choose a random element from a non-empty sequence."""
    cdef unsigned int i = _randbelow(len(seq))
    return seq[i]


def shuffle(list seq):
    """Shuffle list x in place, and return None.
    """
    cdef unsigned int i, j
    randbelow = _randbelow
    for i in reversed(range(1, len(seq))):
        j = randbelow(i+1)
        seq[i], seq[j] = seq[j], seq[i]


def choices(population, tuple weights=None, *, tuple cum_weights=None, unsigned int k=1):
    """Return a k sized list of population elements chosen with replacement.

    If the relative weights or cumulative weights are not specified,
    the selections are made with equal probability.

    """
    random = genrand_res53
    cdef unsigned int i, total
    if cum_weights is None:
        if weights is None:
            total = len(population)
            return [population[int(random() * total)] for i in range(k)]
        cum_weights = tuple(_accumulate(weights))
    total = cum_weights[-1]
    bisect = _bisect
    return [population[bisect(cum_weights, random() * total)] for i in range(k)]


def choose_weighted(tuple population, tuple cum_weights):
    """Return an item from population according to provided weights.
    """
    if len(cum_weights) != len(population):
        raise ValueError('The number of weights does not match the population')
    cdef unsigned int total = cum_weights[-1]
    bisect = _bisect
    random = genrand_res53
    return population[bisect(cum_weights, random() * total)]


cpdef double uniform(double a, double b):
    """Get a random number in the range [a, b) or [a, b] depending on rounding.
    """
    return a + (b-a) * genrand_res53()


cpdef double triangular(double low=0.0, double high=1.0, double mode=0.5):
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


cpdef long triangular_int(long low, long high, long mode):
    cdef double c, u = genrand_res53()
    c = (mode - low) / (high - low)
    if u > c:
        u = 1.0 - u
        c = 1.0 - c
        low, high = high, low
    return <long>(low + (high - low) * sqrt(u * c))
