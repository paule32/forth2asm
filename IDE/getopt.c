#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <sys/types.h>

extern char *input_file;
extern char *reput_file;

extern char *optarg;
extern int optind, opterr, optopt;

void
check_console_options(int argc, char **argv)
{
    FILE * file_pile[100];
    int opt, c;
    int idx;

    int w_flag = 0;
    #define macro_w_flag 1

    while (1) {
        opt = optind ? optind : 1;
        idx = 0;
        static struct option long_options[] =
        {
            { "mode",    required_argument, 0, 400 },
            { "auto",    no_argument,       0, 401 },
            { "verbose", no_argument,       0, 402 },
            { "version", no_argument,       0, 404 },
            { "help",    no_argument,       0, 408 },
            { 0     ,    0          ,       0,  0  }
        };

        if ((c = getopt_long(argc, argv, "abc:d", long_options, &idx)) < 0) {
            break;
        }
        switch (c) {
        case 0:
            printf("option %s", long_options[idx].name);
            if (optarg)
                printf(" with arg %s", optarg);
            printf("\n");
            break;

        case 400:
        {
            if (strcmp(optarg,"pascal")) {
                convert_mode = CVT_PASCAL;
            }
            else if (strcmp(optarg,"asm")) {
                convert_mode = CVT_ASM;
            }
            else {
                fprintf(stderr,"unknow converter mode\n");
                return 1;
            }
            //fprintf(stdout,"source file will be converted to: %s\n",optarg);
        }
        break;

        case 401:
            w_flag = macro_w_flag;
            break;

        case 402:
            fprintf(stdout,"option verbose\n");
            break;

        case 404:
            fprintf(stdout,"version: 0.0.1 alpha\n");
            break;

        case 408:
            fprintf(stdout,
            "Fortran Transpiller - options:\n"
            " --mode     mode = asm, pascal\n");
            break;

        case '?':
            break;

        default:
            fprintf(stderr,"?? getopt returned character code 0%o ??\n", c);
        }
    }

    input_file = (char*) malloc(1024);
    reput_file = (char*) malloc(1024);

    if (optind < argc) {
        while (optind < argc) {
            if (!(file_pile[optind] = fopen(argv[optind],"r"))) {
                char buffer[200];
                sprintf(buffer,"can't open file: %s",argv[optind]);
                perror (buffer);
                return 1;
            }
            else
            fclose(file_pile[optind]);

            strcpy(input_file,argv[optind]);
            optind += 1;
        }
    }
    else {
        fprintf(stderr,"no input file specified.\n");
        return 1;
    }
}
