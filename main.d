// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

import sh = lib.Shell : writeh;
import radio.handshake;
import radio.adjust;
import radio.Track;
import radio.Xspf;
import radio.stream;
import tango.io.Console;


int main( char[][] args )
{
    if (args.length != 2)
        return usage();

    switch (args[1])
    {
        case "--version":
        case "-v":
            Cout( "RoofParty " )( RoofParty.v ).newline;
            return 0;
        case "--help":
            usage();
            Cout( "usage: roofparty [-v | --version]" ).newline;
            return 0;
    }

    writeh( "Handshaking" );
    handshake();
    
    writeh( "Adjusting" );
    adjust( args[1] );

    for (;;)
    {
        writeh( "Fetching Playlist" );
        auto xspf = new Xspf;
        
        if (xspf.urls.length is 0)
            break;

        foreach (Track track; xspf.urls)
        {
            writeh( "Streaming `" ~ track.name ~ "'" );
            stream( track.url );
        }
    }
    
    Cerr( "No more tracks available for this station" ).newline;
    
    return 0;
}


int usage()
{
    Cout( "usage: roofparty [" )( sh.purple )( "url" )( sh.reset )( "]" ).newline;
    return 0;
}
