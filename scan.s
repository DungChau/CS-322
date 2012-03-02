/*
   Dung Chau

   Project 4

   CS 322 Winter 2012

   The algorithm function implements (using C-like pseudo code):

  int *new_array;

  if (!(size > 0)){
    return NULL;
  }

  new_array = (int *) malloc((sizeof(int) + size) + 1);
  
  new_array[0] = array[0];

  for (i = 1; i < size; i++) {
    new_array[i] = new_array[i - 1] + array[i];
    if (array[i] > array[i - 1]){
      max_element = array[i];
    }
  }
    
  new_array[size] = max_element;
  return new_array;

	the purpose of all registers that are used in the function:

	+ %sp: stack pointer,top of stack.

	+ %fp: frame pointer.

	+ %i0: register used to store the pointer to the input array
		
	+ %i1: register used to sore size of input array (second param in scan)

	+ %g0: constant 0

	+ %g1: global register used to store variables that will be computed

	+ %o0: register used to store the address of new array in malloc call.

	+ %o2: register used to store max_element variable.

	+ %o3: register also used to calculate array[i] address in for loop.
	
	+ %o4: register used to calculate new_array[i] address in the loop.

	+ %o5: register used within the loop for array or new_array's element values.

	+ %l0: local register holds the offset which is (i * 4).

	+ %l1: local register holds the value of i in for loop.
*/

	.section	".text"
	.align 4
	.global scan
scan:
	save	%sp, -96, %sp    ! start function by allocate minimum 96 bytes in the stack space
	cmp	%i1, 0               ! compare size and 0
	bg	new_array            ! if size > 0 branch at new_array
	nop                      ! delay slot
	mov %g0, %o0             ! store constant 0 to output register in case size <= 0 NULL
	b	end_routine          ! size < 0 branch at end_routine 
	 nop                     ! delay slot 
new_array:         
	mov	%i1, %o0             ! prepare the param for malloc by calculating size of new_array
	sll	%o0, 2, %o0          ! multiply by 4 that is (sizeof(int) + size)
	add	%o0, 1, %o0          ! add 1 in to it to become (sizeof(int) + size) + 1
	call	malloc, 0        ! call malloc
	 nop                     ! delay slot
	ld [%i0], %g1            ! load the value at array[0] to %g1 
	st %g1,[%o0]             ! store it at the first element of new_array -- new_array[0]
	mov 1, %l1               ! set local varibale i = 1 before enter for loop 	
loop:
	cmp %l1, %i1             ! compare i and size of the input array
	bge max_element          ! if i greater than the size than branch at max_element and end the loop 
	nop                      ! delay slot
	sll %l1, 2, %l0          ! multiply i by 4 to get the offset  
	ld [%i0 + %l0], %o3      ! load the value at array[i] into register %o3
	add %o0, %l0, %o4        ! calculate the address of the element new_array[i] by adding address of 
							 ! new_array and the offset above		
	ld [%o4 - 4], %o5        ! get the value at new_array[i - 1] into register %o5
	add %o3, %o5, %g1        ! add new_array[i - 1] + array[i] together
	st %g1, [%o4]            ! new_array[i] = new_array[i - 1] + array[i]
	                         ! store it into new_array[i]
	add %i0, %l0, %o5        ! the address of array[i]
	ld [%o5 - 4], %o5        ! value at array[i - 1]
	cmp %o3, %o5             ! compare value of array[i] and array[i - 1]
	ble loop_inc             ! if array[i] <= array[i - 1] then branch at loop_inc
	nop                      ! delay slot
	mov %o3, %o2             ! if array[i] > array[i - 1] then max_element = array[i] 
loop_inc:
	add %l1, 1, %l1          ! increment i
	b	loop                 ! branch at loop 
	 nop                     ! delay slot
max_element: 
	sll %i1, 2, %g1          ! get the offset by multiplying the size in %i1 by 4 
	st %o2, [%o0 + %g1]      ! store the max_element in %o2 to new_array[size] 
end_routine:
	mov %o0	, %i0            ! move the address in %o0 to the input register %i0 before return to main
	ret                      ! return to main
	restore                  ! restore registers 
	.size	scan, .-scan     ! size of routine 
