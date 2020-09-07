using System.Linq;
using System.Net;
using System.Net.Sockets;

namespace kmty.gist {
    public static class NetworkUtils {

        public static IPAddress GetLocalIPAddress() {
            if (!System.Net.NetworkInformation.NetworkInterface.GetIsNetworkAvailable()) return null;

            IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());

            return host.AddressList.FirstOrDefault(ip => ip.AddressFamily == AddressFamily.InterNetwork);
        }
    }
}
