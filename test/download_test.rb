require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DownloadTest < MiniTest::Test
  describe "download" do
    before do
      DocRaptor.api_key = "something something"
    end

    describe "with good url" do
      it "should give me a valid response" do
        stub_http_response_with("simple_download.pdf", :get)
        DocRaptor.download("https://docraptor.com/download/test-id")
      end
    end

    describe "with bad url" do
      it "should except" do
        assert_raises(DocRaptorError::InvalidDownloadUrlError) do
          DocRaptor.download("something bogus")
        end
      end
    end
  end
end
