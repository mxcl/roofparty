// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module lib.Shell;
import tango.io.Console : Cerr;


const char[] red    = "\033[0;31m";
const char[] purple = "\033[1;35m";
const char[] yellow = "\033[1;33m";

const char[] normal = "\033[0;0m";
const char[] bold   = "\033[1m";
const char[] title  = "\033[1;4m";

const char[] reset  = normal;


void writeh( char[] text )
{
    Cerr( "\033[0;34m==>\033[0;0;1m " )( text )( reset ).newline;
}
