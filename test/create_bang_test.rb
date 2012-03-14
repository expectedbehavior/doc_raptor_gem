require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class CreateBangTest < MiniTest::Unit::TestCase
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
end
