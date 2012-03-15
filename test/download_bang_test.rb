require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DownloadBangTest < MiniTest::Unit::TestCase
  describe "download!" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_download.pdf", :get)
        DocRaptor.download!("test-id")
      end
    end

    describe "with invalid arguments" do
      it "should raise an exception" do
        stub_http_response_with("invalid_download.xml", :get, 400)
        assert_raises(DocRaptorException::DocumentDownloadFailure) {DocRaptor.download!("test-id")}
      end
    end
  end
end
