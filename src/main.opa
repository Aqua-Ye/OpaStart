function build_page(content) {
  <header>

  </header>
  <div role="main">
    {content}
  </div>
  <footer>

  </footer>
}

// Page headers
headers =
  Xhtml.of_string_unsafe("
<!--[if lt IE 9]>
<script src=\"//html5shiv.googlecode.com/svn/trunk/html5.js\"></script>
<![endif]-->") <+>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"></meta>
  <meta name="viewport" content="width=device-width,initial-scale=1"></meta>
  <meta name="description" content="Kick start you Opa project"></meta>
  <link rel="stylesheet" href="/resources/css/style.css"></link>
  <link rel="icon" type="image/gif" href="/resources/img/favicon.gif"></link>
  <script src="/resources/js/modernizr.js"></script>

// Start page
function start() {
  Toto.a();
  page = build_page(
           <p>Hello world</p>
         )
  Resource.full_page(
    "OpaStart - Kick start your webapp in Opa",
    page, headers, {success},
    []
  )
}

// Parse URL
url_parser = parser {
  case (.*): start()
}

// Start the server
Server.start(Server.http, [
  { resources : @static_resource_directory("resources") }, // include resources directory
  { register : [{ doctype : {html5} }] }, // register HTML5 doctype
  { custom : url_parser } // URL parser
])
