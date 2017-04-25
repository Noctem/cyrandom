========
cyrandom
========

A fast Cython package for random number generation.

Performance Comparison
======================

All times are seconds to complete one million iterations (except for shuffle which is 100,000 iterations).
The benchmarking script can be found `here
<https://github.com/Noctem/cyrandom/blob/master/test/benchmark.py>`_.

=========== ======== ========= ========
function    stdlib   cyrandom  speedup
=========== ======== ========= ========
randrange   1.7863   0.12805   13.95x
randint     2.1198   0.12258   17.29x
choice      1.0969   0.05815   18.86x
shuffle     44.806   0.98338   45.56x
choices     3.3938   0.49235   6.89x
uniform     0.28467  0.08858   3.21x
triangular  0.72341  0.10253   7.06x
=========== ======== ========= ========

Be aware that (for performance reasons) there is less input validation in some of these functions than in the standard library, so ensure that your arguments are valid.
