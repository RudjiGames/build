/*
txt2cs: Converts text files to C strings

Compile with:
	gcc txt2cs.c -o txt2cs

Public domain.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv) {
    char const* prefix = "";
    char const* suffix = "\n";
    int noQuote = 0; /* if 1, do not prepend and append quotation marks (") */
    FILE* in = stdin;
    FILE* out = stdout;

    int c;
    while ((c = getopt(argc, argv, "np:s:h")) != -1) {
        switch (c) {
            case 'n': noQuote = 1; break;
            case 'p': prefix = optarg; break;
            case 's': suffix = optarg; break;
            case 'h': 
                      printf("Usage: %s [-n] [-p prefix] [-s suffix] [infile] [outfile]\n", argv[0]);
                      exit(0);
                      break;
        }
    }
    
    if (optind < argc) {
		if (strcmp(argv[optind], "-") != 0) {
			if (!(in = fopen(argv[optind], "r"))) {
				perror(argv[0]);
				exit(1);
			}
		}
        if (optind + 1 < argc) {
			if (strcmp(argv[optind + 1], "-") != 0) {
				if (!(out = fopen(argv[optind + 1], "w"))) {
					perror(argv[0]);
					exit(1);
				}
			}
        }
    }

	fputs(prefix, out);
	if (!noQuote) fputs("\"", out);

	while ((c = fgetc(in)) != -1) {
		switch (c) {
			case '\0': fputs("\\0", out); break;
			case '\t': fputs("\\t", out); break;
			case '\n': fputs("\\n", out); break;
			case '\r': fputs("\\r", out); break;
			case '\\': fputs("\\\\", out); break;
			case '\"': fputs("\\\"", out); break;
			default: fputc(c, out); break;
		}
	}
	if (!noQuote) fputs("\"", out);
	fputs(suffix, out);
}

