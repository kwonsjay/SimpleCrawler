require 'open-uri'


# Define helper method to extract relevant hyperlinks from a single webpage
# Implement some sort of page ranking system, currently based on the number of times each link appears on the page.
def extract_urls(web_address, page_ranks = Hash.new(0))
  urls = page_ranks
  uri = URI.parse(web_address)
  uri.open do |f|
    base_url = f.base_uri.to_s
    f.each_line do |line|
    
      # Check if line includes hyperlink reference
      if line.include?("href=")
      
        # Use regex to extract hyperlink and remove quotation marks
        url = line[/href=(.*?)(\s|>)/, 1][1..-2]
      
        # Select only relevant hyperlinks
        # ex) ignore /favicon.ico or images .jpg .png by selecting
        #     only external http/https and internal html addresses
        if (url.include?("http") || url.include?("html"))
          
          # If internal URL, append to base URL
          if url[0] == "/"
            url = base_url + url
          end
          
          if urls[url]
            urls[url] += 1
          else
            urls[url] = 1
          end
        end
      
      end
    end
  end

  # Return urls sorted by frequency
  return Hash[urls.sort_by{|k,v| v}.reverse]
  
end


# Super simple iterative crawl function that just takes a list of addresses
def crawl(addresses) #, index = Hash.new(0))
  index = Hash.new(0)
  addresses.each do |address|
    index = extract_urls(address, index)
  end
  return index
end