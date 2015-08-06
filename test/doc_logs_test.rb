require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DocLogsTest < MiniTest::Test
  describe "doc_logs" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with bogus arguments" do
      it "should raise an error if something other than an options hash is passed in" do
        assert_raises(ArgumentError) {DocRaptor.doc_logs(true)}
        assert_raises(ArgumentError) {DocRaptor.doc_logs(nil)}
      end
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_doc_logs.xml", :get)
        assert_equal file_fixture("simple_doc_logs.xml"), DocRaptor.doc_logs.body
      end
    end
  end
end
