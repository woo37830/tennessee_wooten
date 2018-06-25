#include <time.h>

main(argc, argv)
int argc;
char *argv[];
{
	long	tptr, tmp, time();
	char	*asctime();
	struct	tm *ts;
	struct	tm *localtime();
	char *s, format = 'x';
	
	while (--argc > 0 && (*++argv)[0] == '-')
		for (s = argv[0]+1; *s != '\0'; s++)
			switch (*s)	{
			case 'n':
				format = 'n';
				break;
			default:
				printf("ddmmyy: illegal option %c\n",*s);
				printf("Usage: ddmmyy [-n]\n");
				break;
			}
		tptr = time(&tmp);
		ts = localtime(&tptr);
		switch (format)	{
		case 'n':
			printf("%02d%02d%02d",ts->tm_mon+1,ts->tm_mday,ts->tm_year);
			break;
		case 'x':
			printf("%d/%d/%d",ts->tm_mon+1,ts->tm_mday,ts->tm_year);
			break;
		}
}
