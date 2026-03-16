
#include "cpmstd.h"
#include "z80std.h"


void
_entry0 (void)
{
    bdos_c_writestr ((char *)"hellorld\n$");
    bdos_p_termcpm ();
    while (1) 
    {
        z80_halt ();
    }
}

/* end of file */
