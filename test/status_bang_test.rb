require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class StatusBangTest < MiniTest::Unit::TestCase
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
