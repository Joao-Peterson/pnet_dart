#include <dart_api_dl.h>
#include "pnet.h"

// init dart api dl so we can make dart aware of this lib
DART_EXPORT intptr_t init_dart_api_dl(void *data){
	return Dart_InitializeApiDL(data);
}

// pnet_callback_common
void pnet_callback_common(pnet_t *pnet, size_t transition, void *data){
	Dart_Port send_port = (Dart_Port)data;											// send port was passed as void*, recast acagin to recover
	Dart_PostInteger_DL(send_port, transition);
}

// call to m_pnet_new to inject the common callback
pnet_t *m_pnet_new_fromdart(
    pnet_matrix_t *neg_arcs_map, 
    pnet_matrix_t *pos_arcs_map, 
    pnet_matrix_t *inhibit_arcs_map, 
    pnet_matrix_t *reset_arcs_map,
    pnet_matrix_t *places_init, 
    pnet_matrix_t *transitions_delay,
    pnet_matrix_t *inputs_map,
    pnet_matrix_t *outputs_map,
    Dart_Port send_port
){	
	return m_pnet_new(
		neg_arcs_map, 
		pos_arcs_map, 
		inhibit_arcs_map, 
		reset_arcs_map,
		places_init, 
		transitions_delay,
		inputs_map,
		outputs_map,
		pnet_callback_common,														// inject common callback
		(void*)send_port															// data to callback will be the sending port of the corresponding receive port on the dart pnet instance 
	);
}

// call to pnet_deserialize to inject the common callback
pnet_t *pnet_deserialize_fromdart(void *data, size_t size, Dart_Port send_port){	
	return pnet_deserialize(
		data,
		size,
		pnet_callback_common,														// inject common callback
		(void*)send_port															// data to callback will be the sending port of the corresponding receive port on the dart pnet instance 
	);
}

// call to pnet_load to inject the common callback
pnet_t *pnet_load_fromdart(char *filename, Dart_Port send_port){	
	return pnet_load(
		filename,
		pnet_callback_common,														// inject common callback
		(void*)send_port															// data to callback will be the sending port of the corresponding receive port on the dart pnet instance 
	);
}
