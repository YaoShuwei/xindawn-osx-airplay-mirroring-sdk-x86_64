#include <pthread.h>
#include <stdlib.h>
#include "xdw_lock.h"
// On sucess, returns 0.
void *xdw_mutex_init(void)
{
	pthread_mutex_t *hmutex = malloc(sizeof(pthread_mutex_t));
	if(pthread_mutex_init(hmutex, NULL))
	{
		free(hmutex);
		return NULL;
	}
	return (void *)hmutex;
}

// On sucess, returns 0.
int xdw_mutex_lock(void *hmutex)
{
	return pthread_mutex_lock((pthread_mutex_t *)hmutex);
}


// On sucess, returns 0.
int xdw_mutex_unlock(void *hmutex)
{
	return pthread_mutex_unlock((pthread_mutex_t *)hmutex);
}


void xdw_mutex_uninit(void *hmutex)
{
	pthread_mutex_destroy((pthread_mutex_t *)hmutex);
	free(hmutex);
}