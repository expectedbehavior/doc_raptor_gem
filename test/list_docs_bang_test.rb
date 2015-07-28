require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ListDocsBangTest < MiniTest::Test
  describe "list_docs!" do
    before do
      DocRaptor.api_key = "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(DocRaptorError::OptionsHashNotHash) {DocRaptor.list_docs!(true)}
        assert_raises(DocRaptorError::OptionsHashNotHash) {DocRaptor.list_docs!(nil)}
      end
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_list_docs.xml", :get)
        assert_equal file_fixture("simple_list_docs.xml"), DocRaptor.list_docs!.body
      end

      it "raise an exception when the list get fails" do
        stub_http_response_with("invalid_list_docs.xml", :get, 422)
        assert_raises(DocRaptorException::DocumentListingFailure) {DocRaptor.list_docs!}
      end
    end
  end
end
