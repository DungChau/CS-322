/*
   Dung Chau

   Project 4

   CS 322 Winter 2012

   The algorithm function implements (using C-like pseudo code):

   	int *new_array;

	if (size > 0){

		new_array = (int *) malloc((sizeof(int) * size) + 1);

		for (int i = 0; i < size; i++) {
			for(int j = 0; j <= i; j++) {
				new_array[i] += array[j];
			}
			if (array[i] > array[i-1]) {
				max_element = array[i];
			}
		}
	}else{
		return NULL;
	}

	new_array[size] = max_element;
	return new_array;


	the purpose of all registers that are used in the function:

	* %sp: stack pointer,top of stack.

	* %fp: frame pointer.

	* %i0: register used to store the pointer to the input array
		
	* %i1: register used to sore size of input array (second param in scan)

	* %g0: constant 0

	* %g1: Global register used to store variables that will be computed

	*      for example: compared or added or shifted.

	* %o0: register used to store the address of new array in malloc call.

	* %o5: register used within the inner for loop.

	* %o3: register also used in for loops.
*/

	.section	".text"
	.align 4
	.global scan
scan:
	save	%sp, -136, %sp	! start callee by allocate 136 bytes
							! in the stack space to store register windows 	
	st	%i0, [%fp+68]		! store the first param (the input array) to location fp + 68
	st	%i1, [%fp+72]		! store the second param (size) to location fp + 72
	st	%g0, [%fp-20]		! store constant 0 to location fp - 20 -- i = 0
	st	%g0, [%fp-28]		! store constant 0 to location fp - 28 -- max_element = 0
	ld	[%fp+72], %g1		! store size of the array to %g1
	cmp	%g1, 0              ! compare if (size <= 0)
	bg	new_array           ! if size > 0 branch at new_array 
	nop                     ! delay slot
	st	%g0, [%fp-36]		! store constant 0 to fp - 36 which is NULL
	b	end_routine			! branch at end_routine
	 nop                    ! delay slot
new_array:
	ld	[%fp+72], %g1       ! load size of the input array to %g1 
	sll	%g1, 2, %g1         ! compute (sizeof(int) * size by left shift 2  	 
	add	%g1, 1, %g1         ! add 1 to %g1 to complete (sizeof(int) * size + 1
	mov	%g1, %o0            ! move the result to %o0
	call	malloc, 0       ! call malloc
	 nop                    ! delay slot
	mov	%o0, %g1            ! move %o0 to %g1 which is address of new array
	st	%g1, [%fp-32]       ! store that address to location fp - 32
outer_loop:
	ld	[%fp-20], %o5       ! load i = 0 to %o5
	ld	[%fp+72], %g1       ! load the input array's size to %g1 
	cmp	%o5, %g1            ! compare i and size of the input array
	bge	last_element        ! take care the last element of the new array
	nop                     ! delay slot
	st	%g0, [%fp-24]       ! store constant 0 to location fp - 24 -- set j = 0 
inner_loop:
	ld	[%fp-24], %o5       ! load value of j to %o5
	ld	[%fp-20], %g1       ! load value of i to %g1
	cmp	%o5, %g1            ! compare i and j
	bg	outer_loop_inc      ! if (j > i) branch at outer_loop_inc to increment i
	nop                     ! delay slot
	sll	%g1, 2, %o5         ! else then multiply i by wordsize and store to %o5
	ld	[%fp-32], %g1       ! load address of new array to %g1
	add	%o5, %g1, %o3       ! calculte the new_array[i] element address by add 
	                        ! %o5 + %g1 and store to %o3
	ld	[%fp-24], %g1       ! load value of j to %g1
	sll	%g1, 2, %o5         ! multiply j by wordsize and store to %o5
	ld	[%fp+68], %g1       ! load the address of the first param array to %g1 
	add	%o5, %g1, %g1       ! calculate address of array[j] element 
	ld	[%o3], %o5          ! load value at new_array[i] to %o5
	ld	[%g1], %g1          ! load value at new_array[j] to %g1
	add	%o5, %g1, %g1       ! add value of %o5 and %g1 to %g1
	st	%g1, [%o3]          ! store the sum result back to new_array[i] memory location
	                        ! that is : new_array[i] += array[j];
	mov	%o3, %g1            ! move the address of new_array[i] to %g1
	ld	[%o3], %o5          ! load new_array[i] value to %o5
	ld	[%g1-4], %g1        ! load new_array[i - 1] value to %g1
	cmp	%o5, %g1            ! compare new_array[i] and new_array[i - 1]
	ble	inner_loop_inc      ! if new_array[i] <= new_array[i - 1] the branch at inner_loop_inc 
	nop                     ! delay slot
	ld	[%fp-20], %g1       ! if not then load value of i to %g1  
	sll	%g1, 2, %o5         ! calculate the distance of new_array[i] from the beginning of array 
	ld	[%fp+68], %g1       ! load the input array address to %g1
	add	%o5, %g1, %g1       ! calculate the address of new_array[i] store to %g1
	ld	[%g1], %g1          ! load the value at new_array[i] to %g1
	st	%g1, [%fp-28]       ! store that value to max_element 
inner_loop_inc:
	ld	[%fp-24], %g1       ! load value of j to %g1
	add	%g1, 1, %g1         ! increment j++
	st	%g1, [%fp-24]       ! store it back to j 
	b	inner_loop          ! branch back at inner_loop
	 nop                    ! delay slot
outer_loop_inc:
	ld	[%fp-20], %g1       ! load value of i to %g1 
	add	%g1, 1, %g1         ! increment i++
	st	%g1, [%fp-20]       ! store it back to i
	b	outer_loop          ! branch back at outer_loop
	 nop                    ! delay slot
last_element:               
	ld	[%fp+72], %g1       ! load the size of the array to %g1
	sll	%g1, 2, %o5         ! calculate the distance from the beginning to new_array[size] 
	ld	[%fp-32], %g1       ! load address of new_array to %g1
	add	%o5, %g1, %o5       ! compute the address of new_array[size] and store in %o5	
	ld	[%fp-28], %g1       ! load value of max_element to %g1 
	st	%g1, [%o5]          ! new_array[size] = max_element
	ld	[%fp-32], %g1       ! load address of new array to %g1  
	st	%g1, [%fp-36]       ! store that address to fp - 36
end_routine:
	ld	[%fp-36], %i0       ! load the new_array to %i0
	ret                     ! return
	restore                 ! restore registers 
	.size	scan, .-scan    ! size of routine  
