#!/usr/bin/env python3

from timeit import repeat


def compare(cy, py, function):
    print('{}\n'
          '~~~~~~~~~~\n'
          'Python: {:.5}\n'
          'Cython: {:.5f}\n'
          '{:.2f}x faster\n\n'.format(function, py, cy, py / cy))


def main():
    cy = min(repeat('random()', setup='from cyrandom import random'))
    py = min(repeat('random()', setup='from random import random'))
    compare(cy, py, 'random')

    cy = min(repeat('randrange(700, 3000)', setup='from cyrandom import randrange'))
    py = min(repeat('randrange(700, 3000)', setup='from random import randrange'))
    compare(cy, py, 'randrange')

    cy = min(repeat('randint(700, 3000)', setup='from cyrandom import randint'))
    py = min(repeat('randint(700, 3000)', setup='from random import randint'))
    compare(cy, py, 'randint')

    cy = min(repeat('choice(seq)', setup='from cyrandom import choice; seq = tuple(range(50, 500))'))
    py = min(repeat('choice(seq)', setup='from random import choice; seq = tuple(range(50, 500))'))
    compare(cy, py, 'choice')

    cy = min(repeat('shuffle(seq)', setup='from cyrandom import shuffle; seq = list(range(50, 500))', number=100000))
    py = min(repeat('shuffle(seq)', setup='from random import shuffle; seq = list(range(50, 500))', number=100000))
    compare(cy, py, 'shuffle')

    cy = min(repeat('choices(seq, weights)', setup='from cyrandom import choices; seq = (-1, 10, 12, 16, 24, 32, 48, 96); weights = (50, 84, 89, 92, 96, 98, 99, 100)'))
    py = min(repeat('choices(seq, weights)', setup='from random import choices; seq = (-1, 10, 12, 16, 24, 32, 48, 96); weights = (50, 84, 89, 92, 96, 98, 99, 100)'))
    compare(cy, py, 'choices')

    cy = min(repeat('choose_weighted(seq, weights)', setup='from cyrandom import choose_weighted; seq = (-1, 10, 12, 16, 24, 32, 48, 96); weights = (50, 84, 89, 92, 96, 98, 99, 100)'))
    print('choose_weighted\n'
          '~~~~~~~~~~~~~~~\n'
          'Cython: {:.5f}\n\n'.format(cy))

    cy = min(repeat('uniform(203.5, 951.2)', setup='from cyrandom import uniform'))
    py = min(repeat('uniform(203.5, 951.2)', setup='from random import uniform'))
    compare(cy, py, 'uniform')

    cy = min(repeat('triangular(203.5, 951.2, 251.7)', setup='from cyrandom import triangular'))
    py = min(repeat('triangular(203.5, 951.2, 251.7)', setup='from random import triangular'))
    compare(cy, py, 'triangular')

    cy = min(repeat('triangular_int(204, 951, 252)', setup='from cyrandom import triangular_int'))
    print('triangular_int\n'
          '~~~~~~~~~~~~~~\n'
          'Cython: {:.5f}\n\n'.format(cy))

if __name__ == '__main__':
    main()
