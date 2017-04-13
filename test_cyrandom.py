#!/usr/bin/env python3

from unittest import main, TestCase

import cyrandom


ITERATIONS = 10000


class TestRNG(TestCase):
    def test_random(self, random=cyrandom.random):
        for _ in range(ITERATIONS):
            rand = random()
            self.assertTrue(0 <= rand <= 1.0)
            self.assertIsInstance(rand, float)

    def test_randrange(self, randrange=cyrandom.randrange):
        for _ in range(ITERATIONS):
            rand = randrange(700, 3000)
            self.assertTrue(700 <= rand < 3000)
            self.assertIsInstance(rand, int)

    def test_randint(self, randint=cyrandom.randint):
        for _ in range(ITERATIONS):
            rand = randint(700, 3000)
            self.assertTrue(700 <= rand <= 3000)
            self.assertIsInstance(rand, int)

    def test_choice(self, choice=cyrandom.choice):
        seq = (7, 13, 47, 84)
        for _ in range(ITERATIONS):
            rand = choice(seq)
            self.assertIn(rand, seq)

    def test_shuffle(self, shuffle=cyrandom.shuffle):
        original = list(range(73, 137))
        for _ in range(ITERATIONS):
            shuffled = original.copy()
            shuffle(shuffled)
            self.assertNotEqual(original, shuffled)
            self.assertIsInstance(shuffled, list)

    def test_choices(self, choices=cyrandom.choices):
        seq = (6, 8, 10, 12, 16, 24, 32, 48)
        for _ in range(ITERATIONS):
            rand = choices(seq, (4, 38, 73, 84, 88, 96, 99, 100))
            self.assertIn(rand[0], seq)
            self.assertIsInstance(rand, list)

    def test_choose_weighted(self, choose_weighted=cyrandom.choose_weighted):
        seq = (6, 8, 10, 12, 16, 24, 32, 48)
        for _ in range(ITERATIONS):
            rand = choose_weighted(seq, (4, 38, 73, 84, 88, 96, 99, 100))
            self.assertIn(rand, seq)

    def test_uniform(self, uniform=cyrandom.uniform):
        for _ in range(ITERATIONS):
            rand = uniform(7.1, 11.3)
            self.assertTrue(7.1 <= rand <= 11.3)
            self.assertIsInstance(rand, float)

    def test_triangular(self, triangular=cyrandom.triangular):
        for _ in range(ITERATIONS):
            rand = triangular(13.7, 47.3, 17.6)
            self.assertTrue(13.7 <= rand <= 47.3)
            self.assertIsInstance(rand, float)

    def test_triangular_int(self, triangular_int=cyrandom.triangular_int):
        for _ in range(ITERATIONS):
            rand = triangular_int(-50, 100, 50)
            self.assertTrue(-50 <= rand <= 100)
            self.assertIsInstance(rand, int)


if __name__ == '__main__':
    main()
