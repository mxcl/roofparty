// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module lib.os.paths;
import The.prefs;
import tango.core.Exception;
import tango.io.FilePath;
import tango.sys.Environment;


char[] applicationSupport()
{
    version( Windows )
    {
        static assert( 0 );
    }
    else
    {
        version( linux )
        {
            return Environment.get( "HOME", "/tmp" ) ~ "/.local/share/Last.fm/";
        }
        else
        {
            return Environment.get( "HOME", "/tmp" ) ~ "/Library/Application Support/Last.fm/";
        }
    }
}


char[] applicationFolder()
{
    return The.prefs.applicationFolder();
}


static this()
{
    //hideous, but effective
    void mkpath( char[] path )
    {
        scope auto fp = new FilePath( path );
        
        if (!fp.exists())        
            try
            {
                fp.createFolder();
            }
            catch (IOException)
            {
                mkpath( fp.parent() );
                fp.createFolder();
            }
    }
    
    mkpath( applicationSupport() );
}
