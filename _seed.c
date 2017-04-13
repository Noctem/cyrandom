#include "Python.h"
#ifdef HAVE_PROCESS_H
#include <process.h> /* needed for getpid() */
#endif
#include "_mersenne.h"

#if PY_MINOR_VERSION >= 6
#define N 624

static int random_seed_urandom(void) {
  unsigned long key[N];

  if (_PyOS_URandomNonblock(key, sizeof(key)) < 0) {
    return -1;
  }
  init_by_array(key, Py_ARRAY_LENGTH(key));
  return 0;
}
#endif

static void random_seed_time_pid(void) {
  _PyTime_t now;
  unsigned long key[5];

  now = _PyTime_GetSystemClock();
  key[0] = (unsigned long)(now & 0xffffffffU);
  key[1] = (unsigned long)(now >> 32);

  key[2] = (unsigned long)getpid();

  now = _PyTime_GetMonotonicClock();
  key[3] = (unsigned long)(now & 0xffffffffU);
  key[4] = (unsigned long)(now >> 32);

  init_by_array(key, Py_ARRAY_LENGTH(key));
}

void random_seed(void) {
#if PY_MINOR_VERSION >= 6
  if (random_seed_urandom() < 0)
#endif
    random_seed_time_pid();
}
