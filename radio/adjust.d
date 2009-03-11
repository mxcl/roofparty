// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module radio.adjust;

import tango.net.http.HttpGet;
import tango.io.Console;
private import tango.text.convert.Integer : toInt;

private import lib.PlainResponse;
private import radio.handshake;


class Exception
{
    this( int i )
    {
        kind = i;
    }
    
    enum Kind
    {
        NotEnoughContent,
        TooFewGroupMembers,
        TooFewFans,
        Unavailable,
        SubscribersOnly,
        TooFewNeighbours,
        StreamerOffline,
        InvalidSession,
        ErrorUnknown
    }
    
    int kind;
}


void adjust( char[] lastfm_url )
{
    char[] url = radio.handshake.baseUrl ~ "/adjust.php"
                 "?session=" ~ radio.handshake.session ~
                 "&url=" ~ lastfm_url ~
                 "&lang=en"; //FIXME
    
    auto get = new HttpGet( url );
    auto response = cast(char[]) get.read;
    auto parameters = new PlainResponse( response );
    
    debug Cerr( response ).newline;
    
    if (parameters["response"] != "OK")
        throw new Exception( toInt( parameters["error"] ) );

    url = parameters["url"];
    name = parameters["stationname"];
    isDiscoverable = parameters["discovery"].toBool();
}


char[] url;
char[] name;
bool isDiscoverable;
