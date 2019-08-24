# Faye Service Gem

This gem can extend a Ruby project such as Rails, Sinatra, Padrino, Rack, etc. It provides a simple way to communicate with any Faye server instance. 

## Prerequisites

> You need to have at least one instance of Faye running locally on your machine. If you do not have an instance of Faye to connect to, consider using this docker container and this Github repo: 

**Github Repo**: https://github.com/amerlescucodez/faye-docker
**Docker Container**: https://cloud.docker.com/repository/registry-1.docker.io/amerlescucodez/docker-faye-redis

> You can use this `docker-compose.yaml` template to get the necessary requirements running locally: 

```
version: "3.7"

services:
  redis:
    image: redis:alpine
    ports:
      - 6379:6379
    restart: always
    networks:
      - primary

  faye:
    image: amerlescucodez/docker-faye-redis:1.0.0
    links:
      - redis
    depends_on:
      - redis
    restart: always
    ports:
      - 4242:4242
    env_file:
      - .faye.env.development
    networks:
      - primary


networks:
  primary:
```

> Then you should be able to execute: 

```
docker-compose up -d
```

> And then be able to access https://localhost:4242/faye/client.js

## Installation into Rails

> Open your `Gemfile` and add the following dependency: 

```ruby
gem "faye_service", "~> 0.0.1", :git => "git@github.com:amerlescucodez/faye-service-gem.git"
```

> Create the configuration file: 

Command Line: 

```ruby
touch config/faye_service.yml
```

Edit `config/faye_service.yml` to: 

```yaml
faye_service: 
	url: http://localhost:4242/faye
	auth_token: YOUR_TOKEN
	auth_service: YOUR TOKEN
```

> Make sure the dependency is being loaded on application boot:

Edit `config/application.rb`:

```ruby
require 'faye_service'
```

## Sending Messages 

#### From A Controller

`app/controllers/sample_controller.rb`

```ruby
class SampleController < ApplicationController
	def index
		FayeService.publish("/channel/name","message")
	end
end
```

#### From A Model
`app/models/sample.rb`

```ruby
class Sample
	def call_with_nothing
		FayeService.publish("/channel/name","static message")
	end
	
	def call_to_user_channel_with(user_id,message)
		FayeService.publish("/channel/user/#{user_id}", message) if user_id.instance_of?(String)
	end
	
	def call_with_big_message
		message = {
			:friends => %w{Claire Walt Ryland Sylvia Mekhi Lili}, 
			:enemies => %w{Batman Robbin Garfield Snoopy}
		}
		FayeService.publish("/channel/name",message)
	end
end
```

`app/controllers/sample_controller.rb`

```ruby
class SampleController < ApplicationController
	def index
		sample = Sample.new
		sample.call_with_nothing
		sample.call_with_user_channel(session[:user_id], params[:message])
		sample.call_with_big_message
	end
end
```

## Receiving Messages

### Include Faye's main JS file

`app/views/layout/application.html.erb`

```ruby
<!DOCTYPE html>
<html>
<head>
  <title>WebSocketsExample</title>
  <%= stylesheet_link_tag    "application", :media => "all" %>
  <%= javascript_include_tag "http://localhost:4242/faye/client.js","application" %>
  <%= csrf_meta_tags %>
</head>
<body>

<%= yield %>

</body>
</html>
```

### Subscribe to Faye Channel within a Controller's View

`app/views/sample/index.html.erb`

```ruby
<h2>Push Notification Example</h2>
<script type="text/javascript">
  $(function() {
    var faye = new Faye.Client('http://localhost:4242/faye');
    faye.subscribe("/my/awesome/channel", function(data) {
      alert(data); 
    });
  });
</script>
```

> `data` is a variable accessible with in the block of `faye.subscribe` that will either contain JSON data or a string. The best practice section in the Faye Server documentation states that you should always send `json` messages to keep things consistant. It'll make your life easier. 


