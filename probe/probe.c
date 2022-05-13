#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

FILE * fp = NULL;
pthread_mutex_t fp_lock = PTHREAD_MUTEX_INITIALIZER;

extern void 
_final_() 
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "---------------------From _final_---------------------\n");
	fclose(fp);
	pthread_mutex_unlock(&fp_lock);
}

extern void 
_init_() 
{
	pthread_mutex_lock(&fp_lock);
	fp = fopen("log", "w");
	fprintf(fp, "---------------------From _init_---------------------\n");
	pthread_mutex_unlock(&fp_lock);
	atexit(_final_);
}

extern void
_probe_lock_(int line, int func_num, char * func, void * lock_var_addr)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "lock: %p : %8s -> line: %d | func_num: %d | lock_var_addr : %p\n", (void *) pthread_self(), func, line, func_num, lock_var_addr);
	pthread_mutex_unlock(&fp_lock);
}

extern void
_probe_unlock_(int line, int func_num, char * func, void * lock_var_addr)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "unlock: %p : %8s -> line: %d | func_num: %d | lock_var_addr : %p\n", (void *) pthread_self(), func, line, func_num, lock_var_addr);
	pthread_mutex_unlock(&fp_lock);
}

extern void
_probe_send_(int line, int func_num, char * func)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "send: %p : %8s -> line: %d | func_num: %d\n", (void *) pthread_self, func, line, func_num);
       	pthread_mutex_unlock(&fp_lock);
}	

extern void
_probe_recv_(int line, int func_num, char * func)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "recv: %p : %8s -> line: %d | func_num: %d\n", (void *) pthread_self, func, line, func_num);
       	pthread_mutex_unlock(&fp_lock);
}

extern void
_probe_thread_spawn_(int line, int func_num, char * func)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "spawn: %p : %8s -> line: %d | func_num: %d\n", (void *) pthread_self, func, line, func_num);
	pthread_mutex_unlock(&fp_lock);
}

extern void
_probe_thread_join_(int line, int func_num, char * func)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "join: %p : %8s -> line: %d | func_num: %d\n", (void *) pthread_self, func, line, func_num);
	pthread_mutex_unlock(&fp_lock);
}
