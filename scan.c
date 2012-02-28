// Scan for SPARC program written in c.
// Dung Chau

#include <stdio.h>
#include <stdlib.h>

int *scan(int *a, int n) {

  int i=0, j=0, max=0;

  if (!(n > 0)){
    return NULL;
  }

  int *new_array = (int *) malloc((sizeof(int) * n) + 1);

  for (i = 0; i < n; ++i) {
    for(j = 0; j <= i; ++j) {
      new_array[i] += a[j];
      if (a[i] > a[i-1]) {
        max = a[i];
      }
    }
  }

  new_array[n] = max;
  return new_array;
}
