#! /usr/sbin/dtrace -C -q -s

/*
    Mac OS X currently does not support byte swapping in DTrace
    <rdar://problem/5235209>, so we do it the hard way.  This assumes
    you're running on Intel.  If not, you'll have to toggle Q_BIG_ENDIAN.
*/

#define Q_BIG_ENDIAN 0

#if Q_BIG_ENDIAN
    #define ntohs(x) ((short)x)
#else
    #define ntohs(x) ((short) (((((short)(x)) & 0x0FF) << 8) | ((((short)(x)) >> 8) & 0x0FF)))
#endif

inline int AF_INET = 2;

syscall::connect:entry,
syscall::connect_nocancel:entry
/
    ! self->trace
/
{
/*    printf("%20s >connect\n", execname); */
    self->connectFD = arg0;
    self->sock = ((socket_t) (curproc->p_fd->fd_ofiles[self->connectFD]->f_fglob->fg_data));
    self->trace = 1;
}

syscall::connect:return,
syscall::connect_nocancel:return
/
       self->trace
    && ((errno == 0) || (errno == EINPROGRESS))
    && (self->sock->so_proto->pr_domain->dom_family == AF_INET)
/
{
    pcb = (struct inpcb *) self->sock->so_pcb;
    localPort  = (uint16_t) pcb->inp_lport;
    remotePort = (uint16_t) pcb->inp_fport;
       printf("%20s  connect %u -> %u\n", execname, ntohs(localPort), ntohs(remotePort));
}

syscall::connect:return,
syscall::connect_nocancel:return
/
    self->trace
/
{
/*    printf("%20s <connect %d\n", execname, errno); */
    self->connectFD = 0;
    self->sock = 0;
    self->trace = 0;
}