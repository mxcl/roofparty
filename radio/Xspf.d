// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module radio.Xspf;

import lib.RoofParty;
import radio.handshake;
import radio.Track;
import tango.net.http.HttpGet;
import tango.text.convert.Integer : toInt;
import tango.text.xml.Document;
import tango.io.Console;


class Xspf
{
    Track[] urls;
    char[] name;
    int skipsLeft;
    
    this()
    {
        parse( fetch() );
    }

    char[] fetch()
    {
        char[] url = radio.handshake.baseUrl ~ "/xspf.php"
                     "?sk=" ~ radio.handshake.session ~
                     "&discovery=0" ~
                     "&desktop=" ~ RoofParty.v;

        auto get = new HttpGet( url );
        auto output = cast(char[]) get.read;
        return output;
    }
    
    void parse( char[] content )
    {
        auto xml = new Document!( char );
        xml.parse( content );

        int getSkipsLeft()
        {
            auto set = xml.query["playlist"]["link"];
            set = set.filter( (xml.Node n) { return n.getAttribute("rel").value == "http://www.last.fm/skipsLeft"; } );
            return toInt( set.nodes[0].value );
        }
        
        Track[] trackList()
        {
            Track[] tracks;
            foreach (tn; xml.query["playlist"]["trackList"]["track"])
            {
                Track t;
                foreach (n; tn.children)
                {
                    switch (n.name)
                    {
                        case "lastfm:trackauth": t.authCode = n.value; break;
                        case "title": t.name = n.value; break;
                        case "creator": t.artist = n.value; break;
                        case "album": t.album = n.value; break;
                        case "duration": t.duration = toInt( n.value ); break;
                        case "lastfm:sponsored": t.sponsor = n.value; break;
                        case "location": t.url = n.value; break;
                        default: break;
                    }
                }
                tracks ~= t;
            }

            return tracks;
        }

        name = xml.query["playlist"]["title"].nodes[0].value;
        skipsLeft = getSkipsLeft();
        urls = trackList();
    }
}
