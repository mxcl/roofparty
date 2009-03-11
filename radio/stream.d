// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module radio.stream;
import RoofParty = lib.RoofParty;
import tango.io.Console;
import tango.net.Uri;
import tango.net.InternetAddress;
import tango.net.SocketConduit;
import tango.text.stream.LineIterator;
import tango.text.convert.Integer;


void stream( char[] url )
{
    auto uri = new Uri( url );
    auto request = new SocketConduit;
    
    scope (exit) request.close();

    request.connect( new InternetAddress( uri.getHost, 80 ) );

    request.output.write( "GET " ~ uri.getPath ~ " HTTP/1.1\r\n" );
    request.output.write( "User-Agent: RoofParty/" ~ RoofParty.v ~ "\r\n" );
    request.output.write( "\r\n" );

    foreach (line; new LineIterator!(char) (request.input))
    {
        Cerr( line ).newline;
          
        if (line.length is 0)
            // headers are done
            break;
    }

    Cout.stream.copy( request );
}
