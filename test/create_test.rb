require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class CreateTest < MiniTest::Unit::TestCase
  describe "calling create" do
    before do
      DocRaptor.api_key "something something"
      DocRaptor.status_id = nil
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
        stub_http_response_with("invalid_pdf.xml", :post, 422)
        response = DocRaptor.create(:document_content => invalid_html)
        assert_equal file_fixture("invalid_pdf.xml"), response.body
        assert_equal 422, response.code
      end

      it "should give me a valid response if I pass some valid content" do
        stub_http_response_with("simple_pdf.pdf", :post)
        assert_equal file_fixture("simple_pdf.pdf"), DocRaptor.create(:document_content => @html_content).body
      end
    end


    describe "with async" do
      it "should give me a response object on successful enqueue" do
        stub_http_response_with("simple_enqueue.json", :post, 200)
        response = DocRaptor.create(:document_url => "http://example.com",
                                    :async => true)
        # HTTParty parties all over kind_of?/is_a?, so we can't use
        # them here.
        assert_equal HTTParty::Response, response.class
        assert_equal response.code, 200
      end

      it "should set the status_id on successful enqueue" do
        stub_http_response_with("simple_enqueue.json", :post,
                                200, 'Content-Type' => "application/json")
        response = DocRaptor.create(:document_url => "http://example.com",
                                    :async => true)

        expected_status_id = JSON.parse(file_fixture("simple_enqueue.json"))["status_id"]
        assert_equal expected_status_id, DocRaptor.status_id
      end

      it "should give me a response object on failure to enqueue" do
        stub_http_response_with("invalid_enqueue.xml", :post, 422)
        response = DocRaptor.create(:document_url => "http://example.com",
                                    :async => true)
        # HTTParty parties all over kind_of?/is_a?, so we can't use
        # them here.
        assert_equal HTTParty::Response, response.class
      end

      it "should not set the status_id on failure to enqueue" do
        stub_http_response_with("invalid_enqueue.xml", :post, 422)
        response = DocRaptor.create(:document_url => "http://example.com",
                                    :async => true)
        assert DocRaptor.status_id.nil?, DocRaptor.status_id
      end
    end
  end
end
