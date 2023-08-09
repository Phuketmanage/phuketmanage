desc "Deploy your app to Heroku and commit the deployment to NewRelic"
task deploy: :environment do
  puts "Deploy your app to Heroku and commit the deployment to NewRelic"

  print "Continue with deployment? (y/n): "
  proceed = gets.chomp

  if proceed == "y"
    puts "Starting Heroku deployment..."
    sh "git push heroku"
    puts "Commit new deploy to New Relic..."
    sh "bundle exec newrelic deployments -r $(git rev-parse --short HEAD) -e production"
    puts "Completed ✅"
  else
    puts "Deployment canceled ❌"
  end
end
