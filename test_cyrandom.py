#!/usr/bin/env python3

from unittest import main, TestCase

import cyrandom


class TestRNG(TestCase):
    def test_randrange(self):
        rand = cyrandom.randrange(700, 3000)
        self.assertTrue(700 <= rand < 3000)
        self.assertIsInstance(rand, int)

    def test_randint(self):
        rand = cyrandom.randint(700, 3000)
        self.assertTrue(700 <= rand <= 3000)
        self.assertIsInstance(rand, int)

    def test_choice(self):
        seq = (7, 13, 47, 84)
        rand = cyrandom.choice(seq)
        self.assertIn(rand, seq)

    def test_shuffle(self):
        original = list(range(73, 137))
        shuffled = original.copy()
        cyrandom.shuffle(shuffled)
        self.assertNotEqual(original, shuffled)
        self.assertIsInstance(shuffled, list)

    def test_choices(self):
        seq = (6, 8, 10, 12, 16, 24, 32, 48)
        rand = cyrandom.choices(seq, (4, 38, 73, 84, 88, 96, 99, 100))
        self.assertIn(rand[0], seq)
        self.assertIsInstance(rand, list)

    def test_choose_weighted(self):
        seq = (6, 8, 10, 12, 16, 24, 32, 48)
        rand = cyrandom.choose_weighted(seq, (4, 38, 73, 84, 88, 96, 99, 100))
        self.assertIn(rand, seq)

    def test_uniform(self):
        rand = cyrandom.uniform(7.1, 11.3)
        self.assertTrue(7.1 <= rand <= 11.3)
        self.assertIsInstance(rand, float)

    def test_triangular(self):
        rand = cyrandom.triangular(13.7, 47.3, 17.6)
        self.assertTrue(13.7 <= rand <= 47.3)
        self.assertIsInstance(rand, float)


if __name__ == '__main__':
    main()
