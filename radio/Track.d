// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module radio.Track;

struct Track
{
    char[] authCode;
    char[] name;
    char[] artist;
    char[] album;
    uint duration;
    char[] sponsor;
    char[] url;
}
