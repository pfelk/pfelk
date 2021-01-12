require 'set'

IPV4_REGEX = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
IPV6_REGEX = /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/

IPV4_PTR = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\.in-addr\.arpa$/i
IPV6_PTR = /^(?:[0-9a-f]\.){31}[0-9a-f]\.ip6\.arpa$/i

def register(params)
  @query_field = params["query_field"]
  @query_type_field = params["query_type_field"]
  @answers_field = params["answers_field"]
end

def filter(event)

  if @query_field.nil?
    event.tag("dns_related_query_field_not_set")
    return [event]
  end
  if @query_type_field.nil?
    event.tag("dns_related_query_type_field_not_set")
    return [event]
  end
  if @answers_field.nil?
    event.tag("dns_related_answers_field_not_set")
    return [event]
  end

  # Tag and quit if any fields aren't present
  [@query_field, @query_type_field, @answers_field].each do |field|
    if event.get(field).nil?
      event.tag("#{field}_not_found")
      return [event]
    end
  end

  query = event.get(@query_field)
  query_type = event.get(@query_type_field)
  answers = event.get(@answers_field)

  related_ip = Set.new( event.get('[related][ip]'))
  related_hostname = Set.new( event.get('[related][domain]'))

  if (query_type == 'A' || query_type == 'AAAA') # A or AAAA
    related_hostname.add(query.downcase)
    Array(answers).each do |answer|
      if (answer =~ IPV4_REGEX) || (answer =~ IPV6_REGEX)
        related_ip.add(answer)
      else
        related_hostname.add(answer)
      end
    end
  elsif query_type == 'PTR' # PTR query
    related_hostname.add(query.downcase)

    Array(answers).each do |answer|
      related_hostname.add(answer)
    end
    if IPV4_PTR.match(query)
      _addr = [query[0,query.length-13].split('.').reverse].join('.')
      related_ip.add(_addr)
    elsif IPV6_PTR.match(query)
      _addr = query[0,query.length-9].reverse.split('.').join().scan(/.{4}/).join(':')
      _addr.gsub!(/\b0{1,3}([\da-f]+)\b/i, '\1')
      # Abbreviate addr
      loop do
        break if _addr.sub!(/\A0:0:0:0:0:0:0:0\z/, '::')
        break if _addr.sub!(/\b0:0:0:0:0:0:0\b/, ':')
        break if _addr.sub!(/\b0:0:0:0:0:0\b/, ':')
        break if _addr.sub!(/\b0:0:0:0:0\b/, ':')
        break if _addr.sub!(/\b0:0:0:0\b/, ':')
        break if _addr.sub!(/\b0:0:0\b/, ':')
        break if _addr.sub!(/\b0:0\b/, ':')
        break
      end
      _addr.sub!(/:{3,}/, '::')

      related_ip.add(_addr)
    end
  end

  if related_ip.size() > 0
    event.set( '[related][ip]', related_ip.to_a )
    event.set( '[dns][resolved_ip]', related_ip.to_a )
  end
  if related_hostname.size() > 0
    event.set( '[related][domain]', related_hostname.to_a )
  end

  return [event]
end
### Validation Tests

test "when query type is A" do
  parameters {{"query_field" => "query", "query_type_field" => "qtype_name", "answers_field" => "answers" }}
  in_event {{"query" => "www.google.com", "qtype_name" => "A", "answers"=>["172.217.6.164", "216.58.218.100"]}}
  expect("related fields are set") {|events|
    events.first.get("[related][domain]") == ["www.google.com"]
    events.first.get("[related][ip]") == ["172.217.6.164", "216.58.218.100"]
  }
end

test "when query type is AAAA" do
  parameters {{"query_field" => "query", "query_type_field" => "qtype_name", "answers_field" => "answers" }}
  in_event {{"query" => "www.google.com", "qtype_name" => "A", "answers"=>["2607:f8b0:4000:804::2004"]}}
  expect("related fields are set") {|events|
    events.first.get("[related][domain]") == ["www.google.com"]
    events.first.get("[related][ip]") == ["2607:f8b0:4000:804::2004"]
  }
end

test "when query type is PTR" do
  parameters {{"query_field" => "query", "query_type_field" => "qtype_name", "answers_field" => "answers" }}
  in_event {{"query" => "100.218.58.216.in-addr.arpa", "qtype_name" => "PTR", "answers"=>["dfw25s07-in-f100.1e100.net", "dfw25s07-in-f4.1e100.net"]}}
  expect("related fields are set") {|events|
    events.first.get("[related][domain]") == ["100.218.58.216.in-addr.arpa", "dfw25s07-in-f100.1e100.net", "dfw25s07-in-f4.1e100.net"]
    events.first.get("[related][ip]") == ["216.58.218.100"]
  }
end

test "when query type is IPv6 PTR" do
  parameters {{"query_field" => "query", "query_type_field" => "qtype_name", "answers_field" => "answers" }}
  in_event {{"query" => "4.0.0.2.0.0.0.0.0.0.0.0.0.0.0.0.4.0.8.0.0.0.0.4.0.b.8.f.7.0.6.2.ip6.arpa", "qtype_name" => "PTR", "answers"=>["dfw25s17-in-x04.1e100.net"]}}
  expect("related fields are set") {|events|
    events.first.get("[related][domain]") == ["4.0.0.2.0.0.0.0.0.0.0.0.0.0.0.0.4.0.8.0.0.0.0.4.0.b.8.f.7.0.6.2.ip6.arpa", "dfw25s17-in-x04.1e100.net"]
    events.first.get("[related][ip]") == ["2607:f8b0:4000:804::2004"]
  }
end
