========
cyrandom
========

A fast Cython package for random number generation.

Performance Comparison
======================

All times are seconds to complete one million iterations (except for shuffle which is 100,000 iterations).
The benchmarking script can be found `here
<https://github.com/Noctem/cyrandom/blob/master/benchmark.py>`_.

=========== ======== ========= ========
function    stdlib   cyrandom  speedup
=========== ======== ========= ========
randrange   1.6768   0.12038   13.93x
randint     1.9949   0.11875   16.8x
choice      1.0404   0.05610   18.55x
shuffle     44.806   0.98338   45.56x
choices     3.3368   0.96160   3.47x
uniform     0.28467  0.08858   3.21x
triangular  0.72341  0.10253   7.06x
=========== ======== ========= ========
