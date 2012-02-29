// Scan for SPARC program written in c.
// Dung Chau

#include <stdio.h>
#include <stdlib.h>

int *scan(int *a, int n) {

  int i,j,max_element = 0;
  int *new_array;

  if (n > 0){
    new_array = (int *) malloc((sizeof(int) * n) + 1);

    for (i = 0; i < n; ++i) {
      for(j = 0; j <= i; ++j) {
        new_array[i] += a[j];
      }
      if (a[i] > a[i-1]) {
        max_element = a[i];
      }
    }
    new_array[n] = max_element;
  }else{
    return NULL;
  }

  return new_array;
}
