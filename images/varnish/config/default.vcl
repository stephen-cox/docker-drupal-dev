##
# Default Varnish config file

acl purge {
  "localhost";
  "127.0.0.1";
}

backend default {
  .host = "web";
  .port = "80";
  .connect_timeout = 600s;
  .first_byte_timeout = 600s;
  .between_bytes_timeout = 600s;
}

acl local {
  "localhost";
}

sub vcl_recv {

  # Set header so Apache can log IP
  remove req.http.X-Forwarded-For;
  set req.http.X-Forwarded-For = client.ip;

  set req.grace = 6h;

  # Check the incoming request type is "PURGE", not "GET" or "POST"
  if (req.request == "PURGE") {
    # Check if the ip coresponds with the acl purge
    if (!client.ip ~ purge) {
    # Return error code 405 (Forbidden) when not
      error 405 "Not allowed.";
    }
    return (lookup);
  }

  if (req.request == "BAN") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    # Normal ban:
    ban("req.http.host == " + req.http.host + "&& req.url == " + req.url);
    #ban("obj.http.x-url ~ " + req.http.x-ban-url + " && obj.http.x-host ~ " + req.http.x-ban-host);
    error 200 "Banned";
  }

  # Do not cache these paths.
  if (req.url ~ "^/status\.php$" ||
      req.url ~ "^/update\.php$" ||
      req.url ~ "^/ooyala/ping$" ||
      req.url ~ "^/admin/build/features" ||
      req.url ~ "^/info/.*$" ||
      req.url ~ "^/flag/.*$" ||
      req.url ~ "^.*/ajax/.*$" ||
      req.url ~ "^.*/ahah/.*$") {
       return (pass);
  }

# Do not allow outside access to cron.php or install.php.
  # @TODO: we may wish to disable install.php access here too.
  if (req.url ~ "^/(cron)\.php$" && !client.ip ~ local) {
    # Have Varnish throw the error directly.
    error 404 "Page not found.";
    # Use a custom error page that you've defined in Drupal at the path "404".
    # set req.url = "/404";
  }

  # Handle compression correctly. Different browsers send different
  # "Accept-Encoding" headers, even though they mostly all support the same
  # compression mechanisms. By consolidating these compression headers into
  # a consistent format, we can reduce the size of the cache and get more hits.=
  # @see: http:// varnish.projects.linpro.no/wiki/FAQ/Compression
  if (req.http.Accept-Encoding) {
    if (req.http.Accept-Encoding ~ "gzip") {
      # If the browser supports it, we'll use gzip.
      set req.http.Accept-Encoding = "gzip";
    }
    else if (req.http.Accept-Encoding ~ "deflate") {
      # Next, try deflate if it is supported.
      set req.http.Accept-Encoding = "deflate";
    }
    else {
      # Unknown algorithm. Remove it and send unencoded.
      unset req.http.Accept-Encoding;
    }
  }

  # Always cache the following file types for all users.
  if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm)(\?[a-z0-9]+)?$") {
    unset req.http.Cookie;
  }

  # Remove all cookies that Drupal doesn't need to know about. ANY remaining
  # cookie will cause the request to pass-through to Apache. For the most part
  # we always set the NO_CACHE cookie after any POST request, disabling the
  # Varnish cache temporarily. The session cookie allows all authenticated users
  # to pass through as long as they're logged in.
  if (req.http.Cookie) {
    set req.http.Cookie = ";" + req.http.Cookie;
    set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
    set req.http.Cookie = regsuball(req.http.Cookie, ";(has_js|SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=", "; \1=");
    set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
    set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

    if (req.http.Cookie == "") {
      # If there are no remaining cookies, remove the cookie header. If there
      # aren't any cookie headers, Varnish's default behavior will be to cache
      # the page.
      unset req.http.Cookie;
    }
    # If there is a session cookie or the NO_CACHE cookie, do not cache the page.
     elsif (req.http.Cookie ~ "(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=") {
      return (pass);
    }
    else {
      # We only reach here if we have the has_js cookie, and we don't have a session.
      # Sadly, Varnish can't seem to handle segmenting on this yet, so we've gone
      # for removing the has_js cookie if you don't have a session.
     unset req.http.Cookie;
    }
  }
}

# Routine used to determine the cache key if storing/retrieving a cached page.
sub vcl_hash {
  # Include cookie in cache hash.
  # This check is unnecessary because we already pass on all cookies.
  # if (req.http.Cookie) {
  #   set req.hash += req.http.Cookie;
  # }
  
  # Ensure we have a separate bin for Safari as it has a different cache-conrol
  # header.
  if (req.http.user-agent ~ "Safari" && !req.http.user-agent ~ "Chrome") {
    hash_data("safari-disable-cache-control");
  }
  
  # If this is a HTTPS request, keep it in a different cache
  if (req.http.X-Forwarded-Proto) {
    hash_data(req.http.X-Forwarded-Proto);
  }
}

# Code determining what to do when serving items from the Apache servers.
sub vcl_fetch {
  # Don't allow static files to set cookies.
  if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm)(\?[a-z0-9]+)?$") {
    # beresp == Back-end response from the web server.
    unset beresp.http.set-cookie;
  }

  # Allow items to be stale if needed.
  set beresp.grace = 6h;
  
  # Force Safari to always check the server as it doesn't respect Vary: cookie.
  # See https://bugs.webkit.org/show_bug.cgi?id=71509
  if (req.http.user-agent ~ "Safari" && !req.http.user-agent ~ "Chrome") {
    set beresp.http.cache-control = "max-age: 0";
  }
  
  # We need this to cache 404s, 301s, 500s. Otherwise, depending on backend but
  # definitely in Drupal's case these responses are not cacheable by default. - Tanc
  if (beresp.status == 404 || beresp.status == 301 || beresp.status == 500) {
    set beresp.ttl = 10m;
  }
  
  set beresp.http.x-url = req.url;
  set beresp.http.x-host = req.http.host;
}


sub vcl_deliver {
  # Set a header to track a cache HIT/MISS - Tanc
  if (obj.hits > 0) {
    set resp.http.X-Varnish-Cache = "HIT";
  }
  else {
    set resp.http.X-Varnish-Cache = "MISS";
  }

  return (deliver);
}

# In the event of an error, show friendlier messages.
sub vcl_error {
  # Redirect to some other URL in the case of a homepage failure.
  #if (req.url ~ "^/?$") {
  #  set obj.status = 302;
  #  set obj.http.Location = "http://backup.example.com/";
  #}

  # Otherwise redirect to the homepage, which will likely be in the cache.
  set obj.http.Content-Type = "text/html; charset=utf-8";
  synthetic {"
<html>
<head>
  <title>Page Unavailable</title>
  <style>
    body { background: #303030; text-align: center; color: white; }
    #page { border: 1px solid #CCC; width: 500px; margin: 100px auto 0; padding: 30px; background: #323232; }
    a, a:link, a:visited { color: #CCC; }
    .error { color: #222; }
  </style>
</head>
<body onload="setTimeout(function() { window.location = '/' }, 5000)">
  <div id="page">
    <h1 class="title">Page Unavailable</h1>
    <p>The page you requested is temporarily unavailable.</p>
    <p>We're redirecting you to the <a href="/">homepage</a> in 5 seconds.</p>
    <div class="error">(Error "} + obj.status + " " + obj.response + {")</div>
  </div>
</body>
</html>
"};
  return (deliver);
}

sub vcl_hit {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged.";
  }
}

sub vcl_miss {
  if (req.request == "PURGE") {
    purge;
    error 200 "Purged.";
  }
}
