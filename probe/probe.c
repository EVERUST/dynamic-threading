#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#ifdef STACKTRACE
	#include <execinfo.h>
	#include <string.h>
	#define BUFFER_SIZE 128
#endif

FILE * fp = NULL;
pthread_mutex_t fp_lock = PTHREAD_MUTEX_INITIALIZER;

extern void _final_();
extern void 
_init_() 
{
	pthread_mutex_lock(&fp_lock);
	fp = fopen("log", "w");
	fprintf(fp, "---------------------From _init_---------------------\n");
	fprintf(fp, "%p :     main\n", (void *) pthread_self());
	pthread_mutex_unlock(&fp_lock);
	atexit(_final_);
}

extern void 
_final_() 
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "---------------------From _final_---------------------\n");
	fclose(fp);
	pthread_mutex_unlock(&fp_lock);
}

extern void
_probe_mutex_(int line, int func_num, char * func, void * lock_var_addr)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "%p : %8s -> line: %d | func_num: %d | lock_var_addr: %p\n", 
							(void *) pthread_self(), func, line, func_num, lock_var_addr);
	
	#ifdef STACKTRACE
		void *buffer[BUFFER_SIZE];
		char **strings;
		char addr2line_arg[256], file_name[64], func_addr[64], result[1024];
		FILE *fp_addr2line = NULL;
		int nptr = backtrace(buffer, BUFFER_SIZE);
		fprintf(fp, "backtrace returned %d addr\n", nptr);

		strings = backtrace_symbols(buffer, nptr);
		if(strings == NULL){
			perror("backtrace_symbols");
			exit(1);
		}
		for(int j = 0; j < nptr; j++){
			fprintf(fp, "\tbacktrace: %s\n", strings[j]);
			sscanf(strings[j], "%s [%s", file_name, func_addr);
			file_name[strlen(file_name)-2] = '\0';
			for(int i = 0; i < strlen(file_name); i++){
				if(file_name[i] == '('){
					file_name[i] = '\0';
					break;
				}
			}
			func_addr[strlen(func_addr)-1] = '\0';
			sprintf(addr2line_arg, "addr2line -f -e %s %s", file_name, func_addr);
			if((fp_addr2line = popen(addr2line_arg, "r")) == NULL){
				perror("popen error\n");
			}
			else{
				while(fgets(result, 1024, fp_addr2line) != NULL){
					if(result[0] == '?') continue;
					else fprintf(fp, "\t\t%s", result);
				}
				//fprintf(fp, "\n");
			}
			pclose(fp_addr2line);
		}
		fprintf(fp, "===================================\n\n");
		free(strings);
	#endif

	pthread_mutex_unlock(&fp_lock);
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
_probe_func_(int line, int func_num, char * func)
{
	pthread_mutex_lock(&fp_lock);
	fprintf(fp, "%p : %8s -> line: %d | func_num: %d |\n", (void *) pthread_self(), func, line, func_num);
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
