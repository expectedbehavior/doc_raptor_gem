DocRaptor
==========

This is a Ruby gem providing a simple wrapper around the DocRaptor API. DocRaptor is a web service that allows you to convert [html to pdf](http://docraptor.com) or html to xls. 


## Usage ######################################################################

The gem will look for your api key in the ENV variable "DOCRAPTOR_API_KEY".  If it is 
not there, you can set it directly by calling:

    DocRaptor.api_key "My API Key Here"

Once an API key is set, you can create documents by calling

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

To get the status of an async request, you can call

   DocRaptor.status(status_id => id_of_last_async_job)

status_id is the value returned from DocRaptor.create when :async is true.  If you have 
just created a document, status_id defaults to the last status_id received from DocRaptor.
This will return a hash containing, at the very least, a key of "status" with a value of 
one of the following: { "completed", "failed", "killed", "queued", "working" }.  If the 
status is "queued", no other information will be available.  If the status is "working", 
there will be a human readable message contained in "message" that gives further details 
as to the state of the document.  If the status is "complete" there will be a key of 
"download_url" that will contain a 2 time use URL that, when visited, will provide your document.  
If the status is "killed", it means the system had to abort your document generation 
process for an unknown reason, most likely it was taking too long to generate.  If the 
status is "failed" you can check the "messages" value for a message and the "validation_errors" 
value for a more detailed reason for the failure to generate your document.

## Meta #######################################################################

Maintained by Expected Behavior

Released under the MIT license. http://github.com/expected-behavior/docraptor-gem
