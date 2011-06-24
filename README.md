DocRaptor
==========

This is a Ruby gem providing a simple wrapper around the DocRaptor API. DocRaptor is a web service that allows you to convert [html to pdf](http://docraptor.com) or html to xls. 


## Usage ######################################################################

The gem will look for your api key in the ENV variable "DOCRAPTOR_API_KEY".  If it is 
not there, you can set it directly by calling:

    DocRaptor.api_key "My API Key Here"

Once an API key is set, you can create documents by calling:

    DocRaptor.create(:document_content => content, :document_type => "pdf", :test => false, :async => false, :callback_url => nil)

This will return an HTTParty respsonse object, the body of which will be the new file 
(or errors, if the request was not valid).  You can pass in "pdf" or "xls" as the
:document_type - default is pdf.  This determines the type of file that DocRaptor will create.
You can pass in true or false for :test - default is false - and this turns on or off
test mode for DocRaptor.  You can pass in true or false for :async - default is false - and 
this submits the document request to be processed asynchronously. If the document is processed 
asynchronously, a status id will be returned as opposed to the contents of the document. You can 
then use <METHOD NAME> to get the status of the document. You can pass in a URL to :callback_url 
to be called once an asynchronous job is complete.  It will be passed a value of "download_url" 
which will contain a URL that when visited will provide you with your document.  This option 
does nothing if :async is not true.  The only required parameter is :document_content, which 
should be a string of html - this will be what DocRaptor turns into your document.

The create call can also take a block, like so:

    DocRaptor.create(:document_content => content) do |file, response|
      #file is a tempfile holding the response body
      #reponse is the HTTParty response object
    end 

To get the status of an async request, you can call:
   DocRaptor.status             # uses the id of the most recently created async job
   DocRaptor.status(status_id)  # query some other async job and make it the "active" async job for the DocRaptor class

status_id is the value returned from DocRaptor.create when :async is true.  If you have 
just created a document, status_id defaults to the last status_id received from DocRaptor.
This will return a hash containing, at the very least, a key of "status" with a value of 
one of the following: { "completed", "failed", "killed", "queued", "working" }.  If the 
status is "queued", no other information will be available.  If the status is "working", 
there will be a human readable message contained in "message" that gives further details 
as to the state of the document.  If the status is "complete" there will be a key of 
"download_url" that will contain a 2 time use URL that, when visited, will provide your 
document.  There will also be a key of "download_key" that can be given to the 
DocRaptor.download function to obtain your document.  If the status is "killed", it means 
the system had to abort your document generation process for an unknown reason, most 
likely it was taking too long to generate.  If the status is "failed" you can check the 
"messages" value for a message and the "validation_errors" value for a more detailed reason 
for the failure to generate your document.

To download an async document, you can visit the URL (download_url) provided via the status 
function or you can call:

   DocRaptor.download                # uses the key of the most recently checked async job which is complete
   DocRaptor.download(download_key)  # use some other complete doc's download key

download_key is the value from the status hash of a call to DocRaptor.status of a 
completed job.  If you have just checked the status of a document and it is completed, 
download_key defaults to that of the document you just checked.  The download function 
works like DocRaptor.create in that you get back either an HTTParty response object or 
you can give it a block.

## Examples ###################################################################
Check the examples directory for some simple examples. To make them work, you will need to have the docraptor gem installed (via bundler or gem install).

For more examples including a full rails example, check https://github.com/expectedbehavior/doc_raptor_examples.

## Meta #######################################################################

Maintained by Expected Behavior

Released under the MIT license. http://github.com/expected-behavior/docraptor-gem
