desc "Deploy your app to Heroku and commit the deployment to NewRelic"
task deploy: :environment do
  puts "Deploy your app to Heroku and commit the deployment to NewRelic"

  print "Continue with deployment? (y/n): "
  proceed = gets.chomp

  if proceed == "y"
    puts "Starting Heroku deployment..."
    sh "git push heroku"
    puts "Commit new deploy to New Relic..."
    sh "newrelic entity deployment create --guid 'NDA2Nzk2M3xBUE18QVBQTElDQVRJT058NDUzNDE4Mjc2' --version $(git rev-parse --short HEAD) --commit $(git rev-parse --short HEAD) --deploymentType 'BASIC' --profile 'prod_eu_4067963_change_tracking'"
    puts "Completed ✅"
  else
    puts "Deployment canceled ❌"
  end
end
