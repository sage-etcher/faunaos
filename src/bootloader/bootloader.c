
#include "crt0.h"
#include "io.h"
#include "test_bios.h"

#include "advantage_prom.h"

void clear(void);

void
main (void)
{
    clear ();
    test_bios ();
    exit (0);
}

void
clear(void)
{
    putchar (PVID_HOME_CURSOR);
    putchar (PVID_CLEAR_TO_EO_SCREEN);
}

/* end of file */
