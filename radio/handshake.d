// Copyright Max Howell <max@last.fm>
// See the GNU General Public Licence for distribution semantics

module radio.handshake;

private static import The.user;
private import Utils = lib.Utils : percentEncoded;
private import RoofParty = lib.RoofParty;
private import lib.PlainResponse;

import tango.io.Console;
import tango.net.http.HttpGet;


char[] session;
char[] baseHost;
char[] basePath;
char[] baseUrl;
char[] streamUrl;
char[] message;
char[] fingerprintUploadUrl;
char[] msg;

bool isSubscriber;
bool isBootstrapPermitted;
bool isBanned;


void handshake()
{
    char[] url = "http://ws.audioscrobbler.com/radio/handshake.php";
    url ~= "?version=" ~ RoofParty.v;
    url ~= "&platform="; //TODO
    url ~= "&platformversion="; //TODO
    url ~= "&username=" ~ Utils.percentEncoded( The.user.name );
    url ~= "&passwordmd5=" ~ The.user.password;
    url ~= "&language=en"; //TODO
    
    auto get = new HttpGet( url );
    char[] output = cast(char[]) get.read;

    debug Cerr( output ).newline;
    
    auto r = new PlainResponse( output );
    
    session = r["session"];
    streamUrl = r["stream_url"];
    isSubscriber = r["subscriber"].toBool();
    baseHost = r["base_url"];
    basePath = r["base_path"];
    message = r["info_message"];
    isBootstrapPermitted = r["permit_bootstrap"].toBool();
    isBanned = r["banned"].toBool();
    fingerprintUploadUrl = r["fingerprint_upload_url"];
    msg = r["msg"];
    
    baseUrl = "http://" ~ baseHost ~ basePath;
}


unittest
{
    The.user.name = "no_such_user_really_honest";
    handshake();
    assert( session == "FAILED" );
    assert( msg == "no such user" );

    The.user.name = "mxcl";
    The.user.password = "bad_md5";
    handshake();
    assert( session == "FAILED" );
    assert( msg== "padd md5 not 32 len" );
}
