# README
Drone Delivery System Backend

Set Up
================================================================================
Before Install You need to install the below mention package or software
1. rvm ,Ruby 2.5.0,Rails 5.2.3 ->https://rvm.io/rvm/install
    
    Install MQTT -> https://subscription.packtpub.com/book/application_development/9781787287815/1/ch01lvl1sec19/learning-about-the-different-quality-of-service-levels 

2. Copy  the repository in your machine

  
3. Run
   
         rvm install ruby-2.5.0

if bundler not found than try this

    gem install bundler
    gem install rails



1. Run

       bundle install

2. Duplicate Config file

    1. database.yml.sample to database.yml

    2. camel_config.yml.sample to camel_config.yml

3. Run
        
         rails db:create

4. Run

         rails db:migrate

5. Run
        
        rails db:seed

In seed DB I have create the 3 drone and 3 warehouse location data in database.

I have also return unit test for testing the completed drone delivery system.

Run
        
        rspec 
