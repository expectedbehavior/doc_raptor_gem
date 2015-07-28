require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class StatusTest < MiniTest::Test
  describe "status" do
    before do
      DocRaptor.api_key = "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_status.json", :get)
        DocRaptor.status("test-id")
      end
    end
  end
end
