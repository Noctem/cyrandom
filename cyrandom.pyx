import bisect as _bisect

from itertools import accumulate as _accumulate

from _seed cimport random_seed
from _mersenne cimport genrand_int32, genrand_res53


random_seed()


cdef unsigned int bit_length(unsigned int n):
    cdef unsigned int length = 0
    while n != 0:
        length += 1
        n >>= 1
    return length


cdef unsigned int getrandbits(unsigned int k):
    return genrand_int32() >> (32 - k)


cdef int randrange(int start, int stop):
    """Choose a random item from range(start, stop).

    This fixes the problem with randint() which includes the
    endpoint; in Python this is usually not what you want.
    """
    cdef unsigned int width = stop - start
    return start + _randbelow(width)


def randint(int a, int b):
    """Return random integer in range [a, b], including both end points.
    """
    return randrange(a, b+1)


cdef unsigned int _randbelow(unsigned int n):
    """Return a random int in the range [0,n).  Raises ValueError if n==0.
    """

    cdef unsigned int k = bit_length(n)   # don't use (n-1) here because n can be 1
    cdef unsigned int r = getrandbits(k)  # 0 <= r < 2**k
    _getrandbits = getrandbits
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


def choices(population, weights=None, *, cum_weights=None, unsigned int k=1):
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
        cum_weights = list(_accumulate(weights))
    bisect = _bisect.bisect
    total = cum_weights[-1]
    return [population[bisect(cum_weights, random() * total)] for i in range(k)]


def choose_weighted(tuple population, tuple cum_weights):
    """Return an item from population according to provided weights.
    """
    if len(cum_weights) != len(population):
        raise ValueError('The number of weights does not match the population')
    cdef unsigned int total = cum_weights[-1]
    bisect = _bisect.bisect
    random = genrand_res53
    return population[bisect(cum_weights, random() * total)]


def uniform(float a, float b):
    """Get a random number in the range [a, b) or [a, b] depending on rounding.
    """
    return a + (b-a) * genrand_res53()


def triangular(float low=0.0, float high=1.0, float mode=0.5):
    """Triangular distribution.

    Continuous distribution bounded by given lower and upper limits,
    and having a given mode value in-between.

    http://en.wikipedia.org/wiki/Triangular_distribution
    """
    cdef float c, u = genrand_res53()
    try:
        c = (mode - low) / (high - low)
    except ZeroDivisionError:
        return low
    if u > c:
        u = 1.0 - u
        c = 1.0 - c
        low, high = high, low
    return low + (high - low) * (u * c) ** 0.5
