#
# This is just an example for a fuzzer auxiliary
# based on the offensive security MSF material
# http://www.offensive-security.com/metasploit-unleashed/
#

msfbase = __FILE__
while File.symlink?(msfbase)
        msfbase = File.expand_path(File.readlink(msfbase), File.dirname(msfbase))
end

$:.unshift(File.join(File.expand_path(File.dirname(msfbase)), 'lib'))
$:.unshift(ENV['MSF_LOCAL_LIB']) if ENV['MSF_LOCAL_LIB']

require 'msf/core'

class Metasploit3 < Msf::Auxiliary
        include Msf::Auxiliary::Scanner

  def initialise
    super(
      'Name'        =>      'UDP To Alice',
      'Description' =>      'Creates a UDP socket and sends stuff',
      'Author'      =>      'Your name here',
      'Version'     =>      '$Revsion 2$',
      'License'     =>      'MSF_License'
    )
    register_options(
      [
        OPT::RPORT(69)
      ],     # changeable via msf-prompt of course
      self.class
    )
  end
  
  def run_host(ip)
    begin
        # here it creates the UDP socket to use:
        udp_sock = Rex::Socket::Udp.create(
        'Context'   =>
          {
          'Msf'         =>  framework,
          'MsfExploit'  =>  self
          }
        )

        times = 10                            # start value
        while (times<=2000)
          slider='A' * times
          # craft the packets with a definable payload
          # here: WRQ of data consisting of a growing Nr. of A letters
          # because everybody always uses A
          # see TFTP RFC for Opcodes here:
          # http://www.rfc-editor.org/rfc/rfc1350.txt

              # 2 bytes   string   1 byte   string     1 byte
              #-----------------------------------------------
              #| 01/     | file-  |   0  |    Mode    |   0  |
              #| 02      | name   |      |            |      |
              # -----------------------------------------------
          pkt = "\x00\x02" +"\x41"+"\x00"+   slider   + "\x00"

          udp_sock.sendto(pkt, ip, datastore['RPORT'])
          print_status("Sent: #{times} x A")

          recv = udp.sock.get(1)              # Capture response
          times += 10
         end
         rescue
    ensure
    udp_sock.close
    end
  end
end