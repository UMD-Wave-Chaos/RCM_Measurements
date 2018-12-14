#include "vxi11_wrapper.h"

namespace vxi11
{
    bool_t who_responded(struct sockaddr_in *addr)
    {
      char str[INET_ADDRSTRLEN];
      const char* an_addr = inet_ntop(AF_INET, &(addr->sin_addr), str, INET_ADDRSTRLEN);
      if ( gfFoundDevs.find( std::string(an_addr) ) != gfFoundDevs.end() ) return 0;
      int port_T = pmap_getport(addr, DEVICE_CORE, DEVICE_CORE_VERSION, IPPROTO_TCP);
      int port_U = pmap_getport(addr, DEVICE_CORE, DEVICE_CORE_VERSION, IPPROTO_UDP);
      gfFoundDevs[ std::string( an_addr ) ] = Ports(port_T, port_U);
      return 0;
    }


    AddrMap find_vxi11_clients()
    {
      enum clnt_stat clnt_stat;
      const size_t MAXSIZE = 100;
      char rcv[MAXSIZE];
      timeval t;
      t.tv_sec = 1;
      t.tv_usec = 0;

      // Why 6 for the protocol for the VXI-11 devices?  Not sure, but the devices
      // will otherwise not respond.
      clnt_stat = clnt_find_services(DEVICE_CORE, DEVICE_CORE_VERSION, 6, &t,
                                     who_responded);
      return gfFoundDevs;
    }
}
