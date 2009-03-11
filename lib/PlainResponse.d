// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module lib.PlainResponse;

import tango.text.stream.LineIterator;
import tango.io.Buffer;


class PlainResponse
{
    this( char[] input )
    {
        foreach (line; new LineIterator!(char)( new Buffer( input ) ))
        {
            if (line.length is 0)
                continue;
        
            int find()
            {
                foreach (int n, char c; line)
                    if (c == '=')
                        return n;
                return 0;
            }

            int n = find();
            char[] first = line[0..n];
            char[] s = line[n+1..$];
            m_keys[first] = s;
        }
    }

    char[] opIndex( char[] key )
    {
        char[]* v = key in m_keys;
        return v ? *v : "";
    }

private:
    char[][char[]] m_keys;
}


bool toBool( char[] s )
{
    return s == "1";
}

