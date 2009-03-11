// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module lib.Utils;

char[] percentEncoded( char[] s1 )
{
    char toHex( char c )
    {
        const char[] hexnumbers = "0123456789ABCDEF";
        return hexnumbers[c & 0xf];
    }
    
    char[] s2;
    
    foreach (char c; s1)
    {
        if (c >= 0x61 && c <= 0x7A // ALPHA
         || c >= 0x41 && c <= 0x5A // ALPHA
         || c >= 0x30 && c <= 0x39 // DIGIT
         || c == 0x2D  // -
         || c == 0x2E  // .
         || c == 0x5F  // _
         || c == 0x7E) // ~ 
        {
            s2 ~= c;
        }
        else {
            s2 ~= '%';
            s2 ~= toHex( (c & 0xf0) >> 4 );
            s2 ~= toHex( (c & 0xf) );
        }
    }
    
    return s2;
}
