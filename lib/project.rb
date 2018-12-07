class Project

attr_accessor :title, :id, :description

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
    @description = attributes.fetch(:description)
  end

  def self.all
    return_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    return_projects.each() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i()
      description = project.fetch("description")
      projects.push(Project.new({:title => title, :id => id, :description => description}))
  end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title, description) VALUES ('#{@title}', '#{@description}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_project)
    self.title().==(another_project.title()).&(self.id().==(another_project.id()))
  end

  def self.find(id)
    found_project = nil
    Project.all().each() do |project|
      if project.id().==(id)
        found_project = project
      end
    end
    found_project
  end

  def volunteers
    project_volunteers = []
    results = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id()};")
    results.each() do |result|
      name = result.fetch("name")
      project_id = result.fetch("project_id").to_i()
      id = result.fetch("id").to_i()
      project_volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    project_volunteers
  end

end
