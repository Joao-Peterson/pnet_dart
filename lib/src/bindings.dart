// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

// ------------------------------------------------------ functions -----------------------------------------------------------------

// bindings for the pnet c library functions, handles the mapping and signatures
class libpnet {
	/// Holds the symbol lookup function.
	final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
		_lookup;

	/// The symbols are looked up in [dynamicLibrary].
	libpnet(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

	/// The symbols are looked up with [lookup].
	libpnet.fromLookup(
		ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
			lookup)
		: _lookup = lookup;

	// ------------------------------------------------------ pnet_error -----------------------------------------------------------------
	
	/// @brief get error code from latest execution
	/// @return pnet_error_t enumerator type
	int pnet_get_error() {
		return _pnet_get_error();
	}

	late final _pnet_get_errorPtr =
		_lookup<ffi.NativeFunction<ffi.Int32 Function()>>('pnet_get_error');
	late final _pnet_get_error = _pnet_get_errorPtr.asFunction<int Function()>();

	/// @brief get error code message as string from latest execution
	/// @return char* string. Do not free!
	ffi.Pointer<ffi.Char> pnet_get_error_msg() {
		return _pnet_get_error_msg();
	}

	late final _pnet_get_error_msgPtr =
		_lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
			'pnet_get_error_msg');
	late final _pnet_get_error_msg =
		_pnet_get_error_msgPtr.asFunction<ffi.Pointer<ffi.Char> Function()>();


	// ------------------------------------------------------ pnet_matrix -----------------------------------------------------------------

	/// @brief creates a new matrix given it's size and values as var args
	ffi.Pointer<pnet_matrix_t> pnet_matrix_new(
		int x,
		int y,
	) {
		return _pnet_matrix_new(
		x,
		y,
		);
	}

	late final _pnet_matrix_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Int, ffi.Int)>>('pnet_matrix_new');
	late final _pnet_matrix_new = _pnet_matrix_newPtr
		.asFunction<ffi.Pointer<pnet_matrix_t> Function(int, int)>();

	/// @brief creates a new matrix fille dwith zeroes
	ffi.Pointer<pnet_matrix_t> pnet_matrix_new_zero(
		int x,
		int y,
	) {
		return _pnet_matrix_new_zero(
		x,
		y,
		);
	}

	late final _pnet_matrix_new_zeroPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Int, ffi.Int)>>('pnet_matrix_new_zero');
	late final _pnet_matrix_new_zero = _pnet_matrix_new_zeroPtr
		.asFunction<ffi.Pointer<pnet_matrix_t> Function(int, int)>();

	/// @brief deletes a matrix
	void pnet_matrix_delete(
		ffi.Pointer<pnet_matrix_t> matrix,
	) {
		return _pnet_matrix_delete(
		matrix,
		);
	}

	late final _pnet_matrix_deletePtr = _lookup<
			ffi.NativeFunction<ffi.Void Function(ffi.Pointer<pnet_matrix_t>)>>(
		'pnet_matrix_delete');
	late final _pnet_matrix_delete = _pnet_matrix_deletePtr
		.asFunction<void Function(ffi.Pointer<pnet_matrix_t>)>();

	/// @brief prints a matrix in ascii form
	void pnet_matrix_print(
		ffi.Pointer<pnet_matrix_t> matrix,
		ffi.Pointer<ffi.Char> name,
	) {
		return _pnet_matrix_print(
		matrix,
		name,
		);
	}

	late final _pnet_matrix_printPtr = _lookup<
		ffi.NativeFunction<
			ffi.Void Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<ffi.Char>)>>('pnet_matrix_print');
	late final _pnet_matrix_print = _pnet_matrix_printPtr.asFunction<
		void Function(ffi.Pointer<pnet_matrix_t>, ffi.Pointer<ffi.Char>)>();

	/// @brief multiply two matrices and returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_mul(
		ffi.Pointer<pnet_matrix_t> a,
		ffi.Pointer<pnet_matrix_t> b,
	) {
		return _pnet_matrix_mul(
		a,
		b,
		);
	}

	late final _pnet_matrix_mulPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_mul');
	late final _pnet_matrix_mul = _pnet_matrix_mulPtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(
			ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief multiply two matrices of same size element by element, returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_mul_by_element(
		ffi.Pointer<pnet_matrix_t> a,
		ffi.Pointer<pnet_matrix_t> b,
	) {
		return _pnet_matrix_mul_by_element(
		a,
		b,
		);
	}

	late final _pnet_matrix_mul_by_elementPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_mul_by_element');
	late final _pnet_matrix_mul_by_element =
		_pnet_matrix_mul_by_elementPtr.asFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief multiply a matrices by a scalar and returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_mul_scalar(
		ffi.Pointer<pnet_matrix_t> a,
		int c,
	) {
		return _pnet_matrix_mul_scalar(
		a,
		c,
		);
	}

	late final _pnet_matrix_mul_scalarPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Pointer<pnet_matrix_t>, ffi.Int)>>('pnet_matrix_mul_scalar');
	late final _pnet_matrix_mul_scalar = _pnet_matrix_mul_scalarPtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>, int)>();

	/// @brief adds two matrices and returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_add(
		ffi.Pointer<pnet_matrix_t> a,
		ffi.Pointer<pnet_matrix_t> b,
	) {
		return _pnet_matrix_add(
		a,
		b,
		);
	}

	late final _pnet_matrix_addPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_add');
	late final _pnet_matrix_add = _pnet_matrix_addPtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(
			ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief executes a and operations on two matrices of same size element by element, returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_and(
		ffi.Pointer<pnet_matrix_t> a,
		ffi.Pointer<pnet_matrix_t> b,
	) {
		return _pnet_matrix_and(
		a,
		b,
		);
	}

	late final _pnet_matrix_andPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_and');
	late final _pnet_matrix_and = _pnet_matrix_andPtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(
			ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief returns a new matrix that is the boolean negation of the input
	ffi.Pointer<pnet_matrix_t> pnet_matrix_neg(
		ffi.Pointer<pnet_matrix_t> a,
	) {
		return _pnet_matrix_neg(
		a,
		);
	}

	late final _pnet_matrix_negPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_neg');
	late final _pnet_matrix_neg = _pnet_matrix_negPtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>)>();

	/// @brief makes a new matrix which is a copy of the input
	ffi.Pointer<pnet_matrix_t> pnet_matrix_duplicate(
		ffi.Pointer<pnet_matrix_t> a,
	) {
		return _pnet_matrix_duplicate(
		a,
		);
	}

	late final _pnet_matrix_duplicatePtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_duplicate');
	late final _pnet_matrix_duplicate = _pnet_matrix_duplicatePtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>)>();

	/// @brief copies the value of the src matrix to the dest matrix
	void pnet_matrix_copy(
		ffi.Pointer<pnet_matrix_t> dest,
		ffi.Pointer<pnet_matrix_t> src,
	) {
		return _pnet_matrix_copy(
		dest,
		src,
		);
	}

	late final _pnet_matrix_copyPtr = _lookup<
		ffi.NativeFunction<
			ffi.Void Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_copy');
	late final _pnet_matrix_copy = _pnet_matrix_copyPtr.asFunction<
		void Function(ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief transpose a matrix and returns a new one
	ffi.Pointer<pnet_matrix_t> pnet_matrix_transpose(
		ffi.Pointer<pnet_matrix_t> matrix,
	) {
		return _pnet_matrix_transpose(
		matrix,
		);
	}

	late final _pnet_matrix_transposePtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_matrix_t> Function(
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_transpose');
	late final _pnet_matrix_transpose = _pnet_matrix_transposePtr.asFunction<
		ffi.Pointer<pnet_matrix_t> Function(ffi.Pointer<pnet_matrix_t>)>();

	/// @brief compares to see if two matrices are equal in a element by element manner
	int pnet_matrix_cmp_eq(
		ffi.Pointer<pnet_matrix_t> a,
		ffi.Pointer<pnet_matrix_t> b,
	) {
		return _pnet_matrix_cmp_eq(
		a,
		b,
		);
	}

	late final _pnet_matrix_cmp_eqPtr = _lookup<
		ffi.NativeFunction<
			ffi.Int Function(ffi.Pointer<pnet_matrix_t>,
				ffi.Pointer<pnet_matrix_t>)>>('pnet_matrix_cmp_eq');
	late final _pnet_matrix_cmp_eq = _pnet_matrix_cmp_eqPtr.asFunction<
		int Function(ffi.Pointer<pnet_matrix_t>, ffi.Pointer<pnet_matrix_t>)>();

	/// @brief sets all values of a matrix to the specified number
	void pnet_matrix_set(
		ffi.Pointer<pnet_matrix_t> m,
		int number,
	) {
		return _pnet_matrix_set(
		m,
		number,
		);
	}

	late final _pnet_matrix_setPtr = _lookup<
		ffi.NativeFunction<
			ffi.Void Function(
				ffi.Pointer<pnet_matrix_t>, ffi.Int)>>('pnet_matrix_set');
	late final _pnet_matrix_set = _pnet_matrix_setPtr
		.asFunction<void Function(ffi.Pointer<pnet_matrix_t>, int)>();

	// ------------------------------------------------------ pnet -----------------------------------------------------------------

	/// @brief Create a new petri net. All values from the inputs are freed automatically
	/// @param neg_arcs_map: matrix of arcs weight/direction, where the rows are the places and the columns are the transitions. Represents the number of tokens to be removed from a place. Only negative values. Can be null
	/// @param pos_arcs_map: matrix of arcs weight/direction, where the rows are the places and the columns are the transitions. Represents the number of tokens to be moved onto a place. Only positive values. Can be null
	/// @param inhibit_arcs_map: matrix of arcs, where the coluns are the places and the rows are the transitions. Dictates the firing of a transition when a place has zero tokens. Values must be 0 or 1, any non zero number counts as 1. Can be null
	/// @param reset_arcs_map: matrix of arcs, where the coluns are the places and the rows are the transitions. When a transition occurs it zeroes out the place tokens. Values must be 0 or 1, any non zero number counts as 1. Can be null
	/// @param places_init: matrix of values, where the columns are the places. The initial values for the places. Values must be a positive value. Must be not null
	/// @param transitions_delay: matrix of values, were the columns are the transitions. While a place has enough tokens, the transitions will delay it's firing. Values must be positive, given in milli seconds (ms). Can be null
	/// @param inputs_map: matrix where the columns are the transitions and the rows are inputs. Represents the type of event that will fire that transistion, given by the enumerator pnet_event_t. Can be null
	/// @param outputs_map: matrix where the columns are the outputs and the rows are places. An output is true when a place has one or more tokens. Values must be 0 or 1, any non zero number counts as 1. Can be null
	/// @param function: callback function of type pnet_callback_t that is called after firing operations asynchronously, useful for timed transitions. Can be NULL
	/// @param data: data given by the user to passed on call to the callback function in it's data parameter. A void pointer. Can be NULL
	/// @return pnet_t struct pointer
	ffi.Pointer<pnet_t> pnet_new(
		ffi.Pointer<pnet_arcs_map_t> pos_arcs_map,
		ffi.Pointer<pnet_arcs_map_t> neg_arcs_map,
		ffi.Pointer<pnet_arcs_map_t> inhibit_arcs_map,
		ffi.Pointer<pnet_arcs_map_t> reset_arcs_map,
		ffi.Pointer<pnet_places_t> places_init,
		ffi.Pointer<pnet_transitions_t> transitions_delay,
		ffi.Pointer<pnet_inputs_map_t> inputs_map,
		ffi.Pointer<pnet_outputs_map_t> outputs_map,
		pnet_callback_t function,
		ffi.Pointer<ffi.Void> data,
	) {
		return _pnet_new(
		pos_arcs_map,
		neg_arcs_map,
		inhibit_arcs_map,
		reset_arcs_map,
		places_init,
		transitions_delay,
		inputs_map,
		outputs_map,
		function,
		data,
		);
	}

	late final _pnet_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_t> Function(
				ffi.Pointer<pnet_arcs_map_t>,
				ffi.Pointer<pnet_arcs_map_t>,
				ffi.Pointer<pnet_arcs_map_t>,
				ffi.Pointer<pnet_arcs_map_t>,
				ffi.Pointer<pnet_places_t>,
				ffi.Pointer<pnet_transitions_t>,
				ffi.Pointer<pnet_inputs_map_t>,
				ffi.Pointer<pnet_outputs_map_t>,
				pnet_callback_t,
				ffi.Pointer<ffi.Void>)>>('pnet_new');
	late final _pnet_new = _pnet_newPtr.asFunction<
		ffi.Pointer<pnet_t> Function(
			ffi.Pointer<pnet_arcs_map_t>,
			ffi.Pointer<pnet_arcs_map_t>,
			ffi.Pointer<pnet_arcs_map_t>,
			ffi.Pointer<pnet_arcs_map_t>,
			ffi.Pointer<pnet_places_t>,
			ffi.Pointer<pnet_transitions_t>,
			ffi.Pointer<pnet_inputs_map_t>,
			ffi.Pointer<pnet_outputs_map_t>,
			pnet_callback_t,
			ffi.Pointer<ffi.Void>)>();

	/// @brief create new arcs map object. It's freed by the calls that receive it as argument
	/// @param transitions_num: number of transitions for the petri net
	/// @param places_num: number of places for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_arcs_map_t> pnet_arcs_map_new(
		int transitions_num,
		int places_num,
	) {
		return _pnet_arcs_map_new(
		transitions_num,
		places_num,
		);
	}

	late final _pnet_arcs_map_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_arcs_map_t> Function(
				ffi.Int, ffi.Int)>>('pnet_arcs_map_new');
	late final _pnet_arcs_map_new = _pnet_arcs_map_newPtr
		.asFunction<ffi.Pointer<pnet_arcs_map_t> Function(int, int)>();

	/// @brief create new places init object. It's freed by the calls that receive it as argument
	/// @param places_num: number of places for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_places_t> pnet_places_init_new(
		int places_num,
	) {
		return _pnet_places_init_new(
		places_num,
		);
	}

	late final _pnet_places_init_newPtr =
		_lookup<ffi.NativeFunction<ffi.Pointer<pnet_places_t> Function(ffi.Int)>>(
			'pnet_places_init_new');
	late final _pnet_places_init_new = _pnet_places_init_newPtr
		.asFunction<ffi.Pointer<pnet_places_t> Function(int)>();

	/// @brief create new transitions delay object. It's freed by the calls that receive it as argument
	/// @param transitions_num: number of transitions for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_transitions_t> pnet_transitions_delay_new(
		int transitions_num,
	) {
		return _pnet_transitions_delay_new(
		transitions_num,
		);
	}

	late final _pnet_transitions_delay_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_transitions_t> Function(
				ffi.Int)>>('pnet_transitions_delay_new');
	late final _pnet_transitions_delay_new = _pnet_transitions_delay_newPtr
		.asFunction<ffi.Pointer<pnet_transitions_t> Function(int)>();

	/// @brief create new inputs map object. It's freed by the calls that receive it as argument
	/// @param transitions_num: number of transitions for the petri net
	/// @param inputs_num: number of inputs for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_inputs_map_t> pnet_inputs_map_new(
		int transitions_num,
		int inputs_num,
	) {
		return _pnet_inputs_map_new(
		transitions_num,
		inputs_num,
		);
	}

	late final _pnet_inputs_map_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_inputs_map_t> Function(
				ffi.Int, ffi.Int)>>('pnet_inputs_map_new');
	late final _pnet_inputs_map_new = _pnet_inputs_map_newPtr
		.asFunction<ffi.Pointer<pnet_inputs_map_t> Function(int, int)>();

	/// @brief create new outputs map object. It's freed by the calls that receive it as argument
	/// @param outputs_num: number of outputs for the petri net
	/// @param places_num: number of places for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_outputs_map_t> pnet_outputs_map_new(
		int outputs_num,
		int places_num,
	) {
		return _pnet_outputs_map_new(
		outputs_num,
		places_num,
		);
	}

	late final _pnet_outputs_map_newPtr = _lookup<
		ffi.NativeFunction<
			ffi.Pointer<pnet_outputs_map_t> Function(
				ffi.Int, ffi.Int)>>('pnet_outputs_map_new');
	late final _pnet_outputs_map_new = _pnet_outputs_map_newPtr
		.asFunction<ffi.Pointer<pnet_outputs_map_t> Function(int, int)>();

	/// @brief create new inputs object. It's freed by the calls that receive it as argument
	/// @param inputs_num: number of outputs for the petri net
	/// @param ...: the values for each index in the matrix, comma separeted
	ffi.Pointer<pnet_inputs_t> pnet_inputs_new(
		int inputs_num,
	) {
		return _pnet_inputs_new(
		inputs_num,
		);
	}

	late final _pnet_inputs_newPtr =
		_lookup<ffi.NativeFunction<ffi.Pointer<pnet_inputs_t> Function(ffi.Int)>>(
			'pnet_inputs_new');
	late final _pnet_inputs_new = _pnet_inputs_newPtr
		.asFunction<ffi.Pointer<pnet_inputs_t> Function(int)>();

	/// @brief delete a pnet
	/// @param pnet: the pnet struct pointer
	void pnet_delete(
		ffi.Pointer<pnet_t> pnet,
	) {
		return _pnet_delete(
		pnet,
		);
	}

	late final _pnet_deletePtr =
		_lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<pnet_t>)>>(
			'pnet_delete');
	late final _pnet_delete =
		_pnet_deletePtr.asFunction<void Function(ffi.Pointer<pnet_t>)>();

	/// @brief fire the transitions based on the inputs and internal state. Sensitive transitions are NOT updated after firing
	/// @param pnet: the pnet struct pointer
	/// @param inputs: matrix of one row and columns the same size of the inputs given on pnet_new()
	void pnet_fire(
		ffi.Pointer<pnet_t> pnet,
		ffi.Pointer<pnet_inputs_t> inputs,
	) {
		return _pnet_fire(
		pnet,
		inputs,
		);
	}

	late final _pnet_firePtr = _lookup<
		ffi.NativeFunction<
			ffi.Void Function(
				ffi.Pointer<pnet_t>, ffi.Pointer<pnet_inputs_t>)>>('pnet_fire');
	late final _pnet_fire = _pnet_firePtr.asFunction<
		void Function(ffi.Pointer<pnet_t>, ffi.Pointer<pnet_inputs_t>)>();

	/// @brief print the current state of the petri net to the stdout. Places, sensibilized transitions and outputs are printed
	/// @param pnet: the pnet struct pointer
	void pnet_print(
		ffi.Pointer<pnet_t> pnet,
	) {
		return _pnet_print(
		pnet,
		);
	}

	late final _pnet_printPtr =
		_lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<pnet_t>)>>(
			'pnet_print');
	late final _pnet_print =
		_pnet_printPtr.asFunction<void Function(ffi.Pointer<pnet_t>)>();

	/// @brief compute if the transitions are sensibilized
	/// @param pnet: the pnet struct pointer
	void pnet_sense(
		ffi.Pointer<pnet_t> pnet,
	) {
		return _pnet_sense(
		pnet,
		);
	}

	late final _pnet_sensePtr =
		_lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<pnet_t>)>>(
			'pnet_sense');
	late final _pnet_sense =
		_pnet_sensePtr.asFunction<void Function(ffi.Pointer<pnet_t>)>();
}

// ------------------------------------------------------ types -----------------------------------------------------------------

/// @brief enum of possible errors genrated bu the library
abstract class pnet_error_t {
	static const int pnet_info_ok = 0;
	static const int pnet_info_no_neg_arcs_nor_inhibit_arcs_provided_no_transition_will_be_sensibilized = 1;
	static const int pnet_info_no_weighted_arcs_nor_reset_arcs_provided_no_token_will_be_moved_or_set = 2;
	static const int pnet_info_inputs_were_passed_but_no_input_map_was_set_when_the_petri_net_was_created = 3;
	static const int pnet_info_no_callback_function_was_passed_while_using_timed_transitions_watch_out = 4;
	static const int pnet_error_no_arcs_were_given = 5;
	static const int pnet_error_place_init_must_have_only_one_row = 6;
	static const int pnet_error_transitions_delay_must_have_only_one_row = 7;
	static const int pnet_error_places_init_must_not_be_null = 8;
	static const int pnet_error_pos_arcs_has_incorrect_number_of_places = 9;
	static const int pnet_error_pos_arcs_has_incorrect_number_of_transitions = 10;
	static const int pnet_error_inhibit_arcs_has_incorrect_number_of_places = 11;
	static const int pnet_error_inhibit_arcs_has_incorrect_number_of_transitions = 12;
	static const int pnet_error_reset_arcs_has_incorrect_number_of_places = 13;
	static const int pnet_error_reset_arcs_has_incorrect_number_of_transitions = 14;
	static const int pnet_error_places_init_has_incorrect_number_of_places_on_its_first_row = 15;
	static const int pnet_error_transitions_delay_has_different_number_of_transitions_in_its_first_row_than_in_the_arcs = 16;
	static const int pnet_error_inputs_has_different_number_of_transitions_in_its_first_row_than_in_the_arcs = 17;
	static const int pnet_error_inputs_there_are_more_than_one_input_per_transition = 18;
	static const int pnet_error_outputs_has_different_number_of_places_in_its_first_columns_than_in_the_arcs = 19;
	static const int pnet_error_pnet_struct_pointer_passed_as_argument_is_null = 20;
	static const int pnet_error_input_matrix_argument_size_doesnt_match_the_input_size_on_the_pnet_provided = 21;
	static const int pnet_error_thread_could_not_be_created = 22;
}

/// @brief matrix of type int, can be constructed by calling pnet_matrix_new(), v_pnet_matrix_new() or pnet_matrix_new_zero()
class pnet_matrix_t extends ffi.Struct {
  /// < matrix columns size
  @ffi.Size()
  external int x;

  /// < matrix rows size
  @ffi.Size()
  external int y;

  /// < pointer to an array of size y that contains pointers to rows of size x
  external ffi.Pointer<ffi.Pointer<ffi.Int>> m;
}

/// @brief type of events used in the input/transition mapping
abstract class pnet_event_t {
  /// < No input event, transition will trigger if sensibilized. Same as 0
  static const int pnet_event_none = 0;

  /// < The input must be 0 then 1 so the transition can trigger
  static const int pnet_event_pos_edge = 1;

  /// < The input must be 1 then 0 so the transition can trigger
  static const int pnet_event_neg_edge = 2;

  /// < The input must be change state from 1 to 0 or vice versa
  static const int pnet_event_any_edge = 3;

  /// < Enumerator check value, don't use!
  static const int pnet_event_t_max = 4;
}

/// @brief struct that represents a petri net
class pnet_t extends ffi.Struct {
  /// < The number of places in the petri net
  @ffi.Size()
  external int num_places;

  /// < The number of transitions in the petri net
  @ffi.Size()
  external int num_transitions;

  /// < The number of inputs in the petri net
  @ffi.Size()
  external int num_inputs;

  /// < The number of outputs in the petri net
  @ffi.Size()
  external int num_outputs;

  /// < Matrix map of negative weighted arcs
  external ffi.Pointer<pnet_matrix_t> neg_arcs_map;

  /// < Matrix map of positive weighted arcs
  external ffi.Pointer<pnet_matrix_t> pos_arcs_map;

  /// < Matrix map of inhibit arcs
  external ffi.Pointer<pnet_matrix_t> inhibit_arcs_map;

  /// < Matrix map of reset arcs
  external ffi.Pointer<pnet_matrix_t> reset_arcs_map;

  /// < Matrix of the initial places tokens
  external ffi.Pointer<pnet_matrix_t> places_init;

  /// < Matrix map of transitions delays in milliseconds
  external ffi.Pointer<pnet_matrix_t> transitions_delay;

  /// < Matrix map of inputs to transitions
  external ffi.Pointer<pnet_matrix_t> inputs_map;

  /// < Matrix map of places to outputs
  external ffi.Pointer<pnet_matrix_t> outputs_map;

  /// < The actual places that hold tokens
  external ffi.Pointer<pnet_matrix_t> places;

  /// < Currently firable transitions
  external ffi.Pointer<pnet_matrix_t> sensitive_transitions;

  /// < The last state of the inputs, used to make edge events
  external ffi.Pointer<pnet_matrix_t> inputs_last;

  /// < The actual output values produced by the petri net
  external ffi.Pointer<pnet_matrix_t> outputs;

  /// < Callback called by the timed thread on state change
  external pnet_callback_t function;

  /// < Data given by the user to passed on call to the callback function
  external ffi.Pointer<ffi.Void> user_data;

  /// < Thread used to time timed transitions
  @pthread_t()
  external int thread;

  /// < Array used to by the timed thread to fire transitions
  external ffi.Pointer<pnet_matrix_t> transition_to_fire;
}

/// @brief typedef for a callback function signature
typedef pnet_callback_t = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Void Function(ffi.Pointer<pnet_t>, ffi.Pointer<ffi.Void>)>>;
typedef pthread_t = ffi.UnsignedLong;

/// @brief pnet places list, created by calling pnet_places_init_new()
class pnet_places_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}

/// @brief pnet transitions list, created by calling pnet_transitions_delay_new()
class pnet_transitions_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}

/// @brief pnet arcs map list, created by calling pnet_arcs_map_new()
class pnet_arcs_map_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}

/// @brief pnet inputs map list, created by calling pnet_inputs_map_new()
class pnet_inputs_map_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}

/// @brief pnet outputs map list, created by calling pnet_outputs_map_new()
class pnet_outputs_map_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}

/// @brief pnet inputs, created by calling pnet_inputs_new()
class pnet_inputs_t extends ffi.Struct {
  external ffi.Pointer<pnet_matrix_t> values;
}
