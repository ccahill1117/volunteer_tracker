require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require("./lib/volunteer")
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get ("/") do
  @volunteers = Volunteer.all()
  @projects = Project.all()
  erb(:index)

end

post ("/projects") do
  @volunteers = Volunteer.all()
  @projects = Project.all()
  title = params['title']
  description = params['description']
  project = Project.new({:title => title, :description => description, :id => nil})
  project.save()
  redirect('/')
end

get("/projects/:id") do
  @project = Project.find(params.fetch("id").to_i())
  erb(:projects)
end
