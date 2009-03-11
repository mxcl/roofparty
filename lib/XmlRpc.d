// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module lib.XmlRpc;

public import tango.core.Variant;

private import tango.text.convert.Integer : toInt;
private import tango.text.Util : substitute;
private import tango.text.xml.Document;
private import tango.io.Console;


private char[] unescape( char[] s )
{
    s.substitute( "&amp;", "&" );
    s.substitute( "&lt;", "<" );
    s.substitute( "&gt;", ">" );
    return s;
}


private Variant parameter( char[] name, char[] value )
{
    switch (name)
    {
        case "i4":
        case "int":
            return Variant( toInt( value ) );
            
        case "boolean":
            return Variant( value == "1" );
            
        case "string":
            return Variant( unescape( value ) );

        case "struct":
        case "array":
        default:
            throw new Exception("Unhandled XmlRpc response parameter");
    }
}


Variant[char[]] parse( char[] s )
{
    auto xml = new Document!( char );
    xml.parse( s );
    
    auto faults = xml.query["fault"];
    if (faults.count)
        throw new Exception("Fault present in XmlRpc response");
    
    Variant[char[]] map;
    
    foreach (e; xml.query["param"] )
    {
        Cout( e.name )( e.value ).newline;
        map[e.name] = parameter( e.name, e.value );
    }
    
    return map;
}
