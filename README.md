##practice milia app - fully functioning multi tenant
-This allows different tenants (organizations)<br>
-Projects built by admins within the tenant/org, you can invite users per project
-saves files with AWS S3 bucket

#If cloning this realize a couple of things

-it's using sqlite3 in development and PostgreSQL in production (gemfile)

##sendgrid- emailing from Heroku
-it's using sendgrid for sign-up email confirmations (set in .baschrc using Cloud9)<br>
```
export SENDGRID_USERNAME=xxxxxxxxxx
export SENDGRID_PASSWORD=xxxxxxxxxx
```

-send grid port (config/environment.rb) :port => '587' for heroku sign-ups :port => '2587' for Cloud9 sign-ups

-config/environments/development.rb and production has something that needs to be addressed:<br>
    development:<br>
    config.action_mailer.default_url_options = { :host => 'http://example.c9users.io'}<br>
    production:<br>
    config.action_mailer.default_url_options = { :host => 'example.herokuapp.com', :protocol => 'https'}

-config/initializers/devise.rb - where the email notifications are coming from:<br>
config.mailer_sender = 'example@example'

##it uses AWS for file storage - just needs an S3 bucket and credentials
Set them for Heroku through your termianl:<br>
```
$ heroku config:set S3_ACCESS_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_SECRET_KEY=xxxxxxxxxxxxxxxxxx
$ heroku config:set S3_BUCKET=xxxxxxxxxxxxxxxxxx
```

-I tried setting these as environment variables for development with no luck:<br>
maybe they were misnamed - I'm really not sure<br>
(set in .baschrc using Cloud9)<br>
```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxx
export AWS_REGION=xxxxxxxxxxxxxxxxxx
export S3_BUCKET=xxxxxxxxxxxxxxxxxx
```

I ended up saving what I needed here and blocking it with .gitignore:<br>
/app/models/mine.rb

Here are the example mine.rb contents:
```
    def upload_to_s3
        s3 = Aws::S3::Resource.new(region:'your-region-1', access_key_id: 'xxxxxxxxxxxxxxxxxx',
        secret_access_key: 'xxxxxxxxxxxxxxxxxx')
        tenant_name = Tenant.find(Thread.current[:tenant_id]).name
        obj = s3.bucket('yourbucketname').object("#{tenant_name}/#{upload.original_filename}")
        obj.upload_file(upload.path, acl:'public-read')
        self.key = obj.public_url
    end
```
The switch happens around line 14 of app/models/artifact.rb:
```
  if Rails.env.development?
    require_relative 'mine'
  else
    def upload_to_s3
        s3 = Aws::S3::Resource.new(ENV["AWS_REGION"], ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"])
        tenant_name = Tenant.find(Thread.current[:tenant_id]).name
        obj = s3.bucket(ENV["S3_BUCKET"]).object("#{tenant_name}/#{upload.original_filename}")
        obj.upload_file(upload.path, acl:'public-read')
        self.key = obj.public_url  
    end
  end
```  
*See, in production it uses the environment variables provided through the terminal to Heroku