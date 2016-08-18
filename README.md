## DEPRECATED

**This gem is no longer maintained. You should use [docraptor-ruby](https://github.com/DocRaptor/docraptor-ruby) instead.**


# DocRaptor

This is a Ruby gem providing a simple wrapper around the DocRaptor API. DocRaptor is a web service that allows you to convert [html to pdf](http://docraptor.com) or [html to xls](http://docraptor.com).


## Usage

The gem will look for your api key in the `ENV` variable `DOCRAPTOR_API_KEY`.  If it is
not there, you can set it directly by calling:

```
DocRaptor.api_key "YOUR_API_KEY_HERE"
```

Once an API key is set, you can create a PDF document by calling:

```
DocRaptor.create(:document_content => content, :test => true)
```

You might want to set other options in that hash:

* `:document_content` - a string containing the content for creating the document
* `:document_url` - a url to visit to get the content for creating the document
* `:document_type` - "pdf" or "xls"; controls the type of document generated; default is "pdf"
* `:name` - an identifier you can use for the document; shows up in doc logs; default is "default"
* `:test` - test mode flag; set to true to while doing testing so the docs won't count against your monthly count; default is false
* `:prince_options` - see [http://docraptor.com/documentation#pdf_options](http://docraptor.com/documentation#pdf_options) (PDFs only)
* `:async` - create the document asynchonously; default is false
* `:callback_url` - a url that we will hit with a status once the asynchronous document has been fully processed

The only required parameter is one of `:document_content` or `:document_url`.

`create` will return an [HTTParty](https://github.com/jnunemaker/httparty) response object, the body of which will be the new file (or errors, if the request was not valid).

`create!` will raise an exception instead of return errors if there is a failure of any sort in the document generation process. It otherwise works in the same way as `create`.

If the document is processed asynchronously, `status_id` will be set on the DocRaptor class. You can then use `DocRaptor.status` to get the current status of the document. When creating an asynchronous doc, you can pass in a URL via `:callback_url` to be called once an asynchronous job is complete.  It will be passed a value of `download_url` which will contain a URL that when visited will provide you with your document.  This option does nothing if `:async` is not set to true.

The `create` call can also take a block, like so:

```
DocRaptor.create(:document_content => content) do |file, response|
  #file is a tempfile holding the response body
  #reponse is the HTTParty response object
end
```

### Async Doc Creation
To get the status of an async request, you can call:

```
# uses the id of the most recently created async job
DocRaptor.status
```
```
# query some other async job and make it the "active" async job for the DocRaptor class
DocRaptor.status(status_id)
```

`status_id` is the value returned from `DocRaptor.create` when `:async` is true.  If you have
just created a document, `status_id` defaults to the last `status_id` received from DocRaptor.
This will return a hash containing, at the very least, a key of `status` with a value of
one of the following: `{"completed", "failed", "killed", "queued", "working"}`.

* If the status is `queued`, no other information will be available.
* If the status is `working`, there will be a human readable message contained in "message" that gives further details as to the state of the document.
* If the status is `complete` there will be a key of "download_url" that will contain a 2 time use URL that, when visited, will provide your document.

There will also be a key of `download_key` that can be given to the `DocRaptor.download` function to obtain your document.  If the status is `killed`, it means the system had to abort your document generation process for an unknown reason, most likely it was taking too long to generate.  If the status is `failed` you can check the `messages` value for a message and the `validation_errors` value for a more detailed reason for the failure to generate your document.

To download an async document, you can visit the URL (`download_url`) provided via the `status`
function or you can call:

```
# uses the key of the most recently checked async job which is complete
DocRaptor.download
```
```
# use some other complete doc's download key
DocRaptor.download(download_key)
```

`download_key` is the value from the status hash of a call to `DocRaptor.status` of a completed job.

* If you have just checked the status of a document and it is completed, `download_key` defaults to that of the document you just checked.

The `download` function works like `DocRaptor.create` in that you get back either an HTTParty response object or you can give it a block.


## Privacy

To help us improve and support DocRaptor, this library will send DocRaptor information about the version of the gem you are using, as well as your ruby runtime. If you would like to not report that data, you can do so by calling `DocRaptor.disable_agent_tracking` when you initialize the library.

At the time of writing, an example user agent string for mri ruby would be `expectedbehavior_doc_raptor_gem/0.4.3 ruby/2.2.2`.

## Examples

Check the examples directory for some simple examples. To make them work, you will need to have the docraptor gem installed (via bundler or gem install).

For more examples including a full rails example, check [https://github.com/expectedbehavior/doc_raptor_examples](https://github.com/expectedbehavior/doc_raptor_examples).

## Meta

Maintained by [Expected Behavior](http://expectedbehavior.com)

Released under the MIT license. [http://github.com/expected-behavior/docraptor-gem](http://github.com/expected-behavior/docraptor-gem)

## Obligatory Raptor

                                                                                ''
                                                                                -'
                                                                               .-
                                                                              .:'
                                                                              :-
                                                                             -s-
                                                                            'sy.
                                                                            .so'
                                                                            -/-
                                                                           '::.
                                                                           .+o'
                                                                          '+hs
                                                                          .yh+
                                                                          :ys-
                                                                          :+/'
                                                                         '/+:
                                                                         :sy:
                                                                        'shh.
                                                                        -yyo
                                                                        -//-
                                                                       ':/:'
                                                                       :+o/
                                                                      'syy:
                           '                                          :yyy.
                        '':+-                                        '/oo+
                    '..-++o++//-'                                    .///.
                ./++oooooooso+oo+.                                  '/++/'
               -oosssoosydddhhsosy+-                                :yyh+
              .sssyssshddyhddhhhsyso'                              -yhhh-
              -syyyyddmmmhyddhyhysyy/                             '+shho'
             -syyydmmmddmddhhyyyysyhy-                           '-//+o-
           ./yyhhmmddddhhhyysssyyyydhy.                         '/ooo+:
          :syyydmhdddddhyyyssyyyyhhhhho                        .+hddhs.
        '/ossyhhhhhddhhhhhhdhhyhhhhhhhh:       ''....''       .+shddd/
        :syosyhhhyyyyhdmddhyyyyyyyhhdhhh-''.-:/++++oooo+/:. ':+ooooso'
       .+ysoosyyyyyydNmmdyyyyyoosyhdddddho//+osooooosyhyooyoooyhhys+.
       -oo+++sssyyhmNmmdyyyo-'-/osyhhdddddhssssyyyssyyhhhsyhhysshhy:
      ':+++oossyhdNNmmhyy+.    -/+osyhhddddddhhhhhyyyhdddhhdmhhyyho'
        '''.:yydNmmdhyy+.       ./+syyhhddddmddhdhhyyhdmmdddmmhhys.
            /yydmmhyys:          .:+osyhdddddddddhhhhdmmddhyyddyy+
           '+syhyssyo.           .+/+oshhdddddddhhhhhdNmhyysoohyyo'
           '/+sooss/'            /oo+ooshddddhhhhyhhdmmhysyhdsshyo-
            -/o++:'              /++osssyhhhhyyyyyyhdddhhhhmNyohys:
              '                 :o+++osssyyyyyyssyyhdmmddmmmmhohhs+
                               .oo++oosssyyyysyssyhmNNmmmmdhyooddyo'
                               :/+ssysssyyysyyyyyhdmNNNmyyhyooshhys'
                              ':/sddddhysyssyyyyhhhdmNNysosoooshhyy'
                              ./oyddmmmmmhhyyyyssoosyhdy+ososyshhh+
                              -+yhdddmNmNNmNNmmo/+oyyhhs+osshyshhh/
                              :+hdhhddmmmmmmmNd'  '-syhyoshhhsyyyyo'
                             .:odmddddmNmmdddmm+    ./ssoshdhsyysss/
                             ./ohmmmy:smmddhhdmh'     ''-oshhysssyys'
                             ./+hdmNd-:mmddhhddo        .osydhhyyhho'
                             ./+ydmNMmydmmdddhh:        .ssyhddyyhh/
                              odsydmNMNydmmddhh-        .ossyhdhyyy.
                              ./'-sdmNN+/dmmddd:         +hyssysyyh-
                                  'oyh/.'odddmm/         ohysoossyho'
                                   ':hd:'/hhhdmo         '.-/+ooosys'
                                     '-+osyhhdmy'            '/+osy/
                                         .syyhhh.            '/+osy.
                                         'osssys'            -+ooss.
                                         '/ooos+'           '/oosss.
                                          :oo+o+'          -shhhyyy/
                                         '+ss+oy.         .yNmmmdhys.
                                         smNdshd:          -ydmdhyys/'
                                        .mNNdydms           :yhyyhy++/.
                                       '+ddyyhdy:            -sddddo++s+'
                                  '.-/ohdmNdyyy'             'odmyss+odd/
                              -+oyhhhhdmmmmdhy+               ':-    '.:.
                            'sMmoosshmmNdmmh/.
                            -oo+---/ddmMhho'
                                    :++:-'
