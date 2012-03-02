// Scan for SPARC program written in c.
// Dung Chau

#include <stdio.h>
#include <stdlib.h>

int *scan(int *array, int size) {

  int i,max_element = 0;
  int *new_array;

  if (!(size > 0)){
    return NULL;
  }

  new_array = (int *) malloc((sizeof(int) * size) + 1);
  
  new_array[0] = array[0];

  for (i = 1; i < size; i++) {
    new_array[i] = new_array[i - 1] + array[i];
    if (array[i] > array[i - 1]){
      max_element = array[i];
    }
  }
    
  new_array[size] = max_element;
  return new_array;
}
