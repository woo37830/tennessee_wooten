#include <time.h>

main()
{
	long	tptr, tmp, time();
	char	*asctime();
	struct	tm *ts;
	struct	tm *localtime();
	
	tptr = time(&tmp);
	printf("\nresult of time is %ld",tptr);
	ts = localtime(&tptr);
	printf("\nTodays date is %d/%d/%d",ts->tm_mon+1,ts->tm_mday,ts->tm_year);
	printf("\n The current date-time is : %s\n",asctime(localtime(&tptr)));
}
