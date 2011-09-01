require File.expand_path(File.dirname(__FILE__) + "/test_helper")

# pull in the docraptor code
require File.expand_path(File.dirname(__FILE__) + "/../lib/doc_raptor")

class DocRaptorTest < MiniTest::Unit::TestCase

  describe "test API keys" do
    before do
      DocRaptor.default_options.delete :api_key
      ENV.delete "DOCRAPTOR_API_KEY"
      @test_key = "Test Key!"
    end

    it "should throw an error if no api key is provided via a key, set in the environment, or already set on the DocRaptor class object" do
      assert_raises(DocRaptorError::NoApiKeyProvidedError) {DocRaptor.api_key}
    end

    it "should read the api key from the ENV" do
      ENV["DOCRAPTOR_API_KEY"] = @test_key
      assert_equal @test_key, DocRaptor.api_key
    end

    it "changes to the ENV variable shouldn't be implicitly picked up" do
      ENV["DOCRAPTOR_API_KEY"] = @test_key
      DocRaptor.api_key

      ENV["DOCRAPTOR_API_KEY"] = "some other key"
      assert_equal @test_key, DocRaptor.api_key
    end

    it "should use the passed in key" do
      assert_equal @test_key, DocRaptor.api_key(@test_key)
    end

    it "should persist the passed in key on subsequent calls" do
      DocRaptor.api_key(@test_key)
      assert_equal @test_key, DocRaptor.api_key
    end

    it "should override keys when passed in explicitly" do
      other_key = "some other key"
      DocRaptor.api_key(@test_key)
      assert_equal other_key, DocRaptor.api_key(other_key)
    end

    it "should persist overridden keys" do
      other_key = "some other key"
      DocRaptor.api_key(@test_key)
      DocRaptor.api_key(other_key)
      assert_equal other_key, DocRaptor.api_key
    end
  end

  describe "calling create" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(ArgumentError) {DocRaptor.create(true)}
        assert_raises(ArgumentError) {DocRaptor.create(nil)}
      end

      it "should raise an error if document_content and document_url are both unset" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create({:herped => :the_derp})}
      end

      it "should raise an error if document_content is passed by is blank" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create(:document_content => nil)}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create(:document_content => "")}
      end

      it "should raise an error if document_url is passed by is blank" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create(:document_url => nil)}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create(:document_url => "")}
      end
    end
    
    describe "with document_content" do
      before do
        @html_content = "<html><body>Hey</body></html>"
      end

      it "should give me some error message if pass some invalid content" do
        invalid_html = "<herp"
        stub_http_response_with("invalid_pdf", :post, 422)
        response = DocRaptor.create(:document_content => invalid_html)
        assert_equal file_fixture("invalid_pdf"), response.body
        assert_equal 422, response.code
      end

      it "should give me a valid response if I pass some valid content" do
        stub_http_response_with("simple_pdf", :post)
        assert_equal file_fixture("simple_pdf"), DocRaptor.create(:document_content => @html_content).body
      end
    end
  end
  
  describe "calling create!" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(ArgumentError) {DocRaptor.create!(true)}
        assert_raises(ArgumentError) {DocRaptor.create!(nil)}
      end

      it "should raise an error if document_content and document_url are both unset" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!({:herped => :the_derp})}
      end

      it "should raise an error if document_content is passed by is blank" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!(:document_content => nil)}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!(:document_content => "")}
      end

      it "should raise an error if document_url is passed by is blank" do
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!(:document_url => nil)}
        assert_raises(DocRaptorError::NoContentError) {DocRaptor.create!(:document_url => "")}
      end
    end
    
    describe "with document_content" do
      before do
        @html_content = "<html><body>Hey</body></html>"
      end

      it "should give me some error message if pass some invalid content" do
        invalid_html = "<herp"
        stub_http_response_with("invalid_pdf", :post, 422)
        assert_raises(DocRaptorException::DocumentCreationFailure) {DocRaptor.create!(:document_content => invalid_html)}
      end

      it "should give me a valid response if I pass some valid content" do
        stub_http_response_with("simple_pdf", :post)
        assert_equal file_fixture("simple_pdf"), DocRaptor.create!(:document_content => @html_content).body
      end
    end
  end
  
  describe "list_docs" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(ArgumentError) {DocRaptor.list_docs(true)}
        assert_raises(ArgumentError) {DocRaptor.list_docs(nil)}
      end
    end
    
    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_list_docs", :get)
        assert_equal file_fixture("simple_list_docs"), DocRaptor.list_docs.body
      end
    end
  end

  describe "list_docs!" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(ArgumentError) {DocRaptor.list_docs!(true)}
        assert_raises(ArgumentError) {DocRaptor.list_docs!(nil)}
      end
    end
    
    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_list_docs", :get)
        assert_equal file_fixture("simple_list_docs"), DocRaptor.list_docs!.body
      end

      it "raise an exception when the list get fails" do
        stub_http_response_with("invalid_list_docs", :get, 422)
        assert_raises(DocRaptorException::DocumentListingFailure) {DocRaptor.list_docs!}
      end
    end
  end

  describe "status" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_status", :get)
        DocRaptor.status("test-id")
      end
    end
  end

  describe "status!" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_status", :get)
        DocRaptor.status!("test-id")
      end
    end

    describe "with invalid arguments" do
      it "should raise an exception" do
        stub_http_response_with("invalid_status", :get, 403)
        assert_raises(DocRaptorException::DocumentStatusFailure) {DocRaptor.status!("test-id")}
      end
    end
  end
end
