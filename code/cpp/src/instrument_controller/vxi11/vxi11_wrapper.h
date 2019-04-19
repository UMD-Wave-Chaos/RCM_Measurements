#ifndef VXI11_WRAPPER
#define VXI11_WRAPPER

#include <map>
#include <string>
#include <iostream>
#include "clnt_find_services.h"
#include <rpc/pmap_clnt.h>
#include <arpa/inet.h>
#include "vxi11_user.h"

using std::endl;
using  std::cout;

namespace vxi11
{
    class Ports {
      public:
        Ports(int tcp = 0, int udp = 0) : tcp_port(tcp), udp_port(udp) {}
        int tcp_port;
        int udp_port;
    };

    typedef std::map<std::string, Ports> AddrMap;
    static AddrMap gfFoundDevs;

    bool_t who_responded(struct sockaddr_in *addr);


    AddrMap find_vxi11_clients();
}


#endif //#define _VXI11_WRAPPER
