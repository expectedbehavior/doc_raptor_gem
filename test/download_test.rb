require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DownloadTest < MiniTest::Test
  describe "download" do
    before do
      DocRaptor.api_key "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_download.pdf", :get)
        DocRaptor.download("test-id")
      end
    end
  end
end
