DocRaptor
==========

This is a Ruby gem providing a simple wrapper around the DocRaptor API.


## Usage ######################################################################

The gem will look for your api key in the ENV variable "DOCRAPTOR_API_KEY".  If it is 
not there, you can set it directly by calling:

    DocRaptor.api_key "My API Key Here"

Once an API key is set, you can create documents by calling

    DocRaptor.create(:document_content => content, :document_type => "pdf", :test => false)

This will return an HTTParty respsonse object, the body of which will be the new file 
(or errors, if the request was not valid).  You can pass in "pdf" or "xls" as the
:document_type - default is pdf.  This determines the type of file that DocRaptor will create.
You can pass in true or false for :test - default is false - and this turns on or off
test mode for DocRaptor.  The only required parameter is :document_content, which should be a
string of html - this will be what DocRaptor turns into your document.

The create call can also take a block, like so:

    DocRaptor.create(:document_content => content) do |file, response|
      #file is a tempfile holding the response body
      #reponse is the HTTParty response object
    end 

## Meta #######################################################################

Maintained by Expected Behavior

Released under the MIT license. http://github.com/expected-behavior/docraptor-gem
