require "rubygems"
require "doc_raptor"

QUARTER_SECOND = 0.25
FIVE_MINUTES   = 300

DocRaptor.api_key = "YOUR_API_KEY_HERE"

pdf_html = "<html><body>I am an asynchronously-created doc.</body></html>"

def pretty_time; Time.now.strftime("%I:%M:%S.%L %p"); end
def print_status(status = {}); puts("#{pretty_time} - Status: #{status['status']}");end

response = DocRaptor.create(:document_content => pdf_html,
                            :name             => "docraptor_sample.pdf",
                            :document_type    => "pdf",
                            :test             => true,
                            :async            => true)
status_id = response["status_id"]

# This timeout is 5 minutes.
# If there is no load on the background processors, this test should take less than 5s (generally <1s
# from enqueue to available for download). It is possible production will be backed up with real jobs,
# hence the timeout.
timeout_time = Time.now + FIVE_MINUTES

status = {"status" => "queued"}
print_status(status)
loop do
  status = DocRaptor.status(status_id)
  print_status(status)
  break if (["completed","failed"].include?(status["status"])) || Time.now >= timeout_time
  sleep(QUARTER_SECOND)
end

if status["status"] == "completed"
  file = DocRaptor.download(status["download_url"])
  File.open("docraptor_sample.pdf", "w+b") do |f|
    f.write(file.response.body)
  end
  puts("#{pretty_time} - File downloaded to docraptor_sample.pdf")
else
  puts("Failed to generate document. Please contact DocRaptor " \
       "Support (support@docraptor.com) if you need assistance.")
end
