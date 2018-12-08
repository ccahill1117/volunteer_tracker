require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require("./lib/volunteer")
require("pg")
require("pry")

DB = PG.connect({:dbname => "volunteer_tracker"})

get ("/") do
  @volunteers = Volunteer.all()
  @projects = Project.all()
  # binding.pry
  erb(:index)
end

post ("/projects") do
  @volunteers = Volunteer.all()
  @projects = Project.all()
  title = params['title']
  description = params['description']
  project = Project.new({:title => title, :id => nil, :description => description})
  project.save()
  redirect('/')
end

post ("/volunteers") do
  @volunteers = Volunteer.all()
  @projects = Project.all()
  name = params['name']
  project_id = params['project_id'].to_i()
  volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => nil})
  volunteer.save()
  redirect('/')
end

get("/projects/:id") do
  @project = Project.find(params.fetch("id").to_i())
  @volunteers = Volunteer.all()
  erb(:projects)
end

patch("/projects/:id") do
  volunteer_id = params['volunteer'].to_i()
  @project = Project.find(params.fetch("id").to_i())
  @volunteer = Volunteer.find(volunteer_id)
  # binding.pry
  @volunteer.update_project_id({:project_id => @project.id})
  redirect('/')
end

get("/volunteers/:id") do
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @projects = Project.all()
  erb(:volunteers)
end

get("/projects/:id/edit") do
  @project = Project.find(params.fetch("id").to_i())

  erb(:project_edit)
end

get("/volunteers/:id/edit") do
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  erb(:volunteer_edit)
end

patch("/projects/:id")do
  title = params["title"]
  @project = Project.find(params.fetch("id").to_i())
  # binding.pry
  @project.update_title({:title => title})
  redirect('/')
end

delete("/projects/:id")do
  @project = Project.find(params.fetch("id").to_i())
  @project.delete()
  @projects = Project.all()
  redirect('/')
end

patch("/volunteers/:id")do
  name = params["name"]
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  # binding.pry
  @volunteer.update_name({:name => name})
  redirect('/')
end

delete("/volunteers/:id")do
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @volunteer.delete()
  @volunteers = Volunteer.all()
  redirect('/')
end
