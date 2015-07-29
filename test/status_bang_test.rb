require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class StatusBangTest < MiniTest::Test
  describe "status!" do
    before do
      DocRaptor.api_key = "something something"
    end

    describe "with good arguments" do
      it "should give me a valid response" do
        stub_http_response_with("simple_status.json", :get)
        DocRaptor.status!("test-id")
      end
    end

    describe "with invalid arguments" do
      it "should raise an exception" do
        stub_http_response_with("invalid_status.xml", :get, 403)
        assert_raises(DocRaptorException::DocumentStatusFailure) {DocRaptor.status!("test-id")}
      end
    end
  end
end
