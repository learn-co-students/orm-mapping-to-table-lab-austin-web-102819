class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade 
  attr_reader :id

  def initialize(name, grade, id=nil)
    
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    stm = <<-SQL
          CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
          )
          SQL
    sql = DB[:conn].prepare(stm)
    sql.execute
  end

  def self.drop_table
    stm = <<-SQL
          DROP TABLE students
          SQL
    sql = DB[:conn].prepare(stm)
    sql.execute
  end

  def save
    stm = <<-SQL
          INSERT INTO students (name, grade) VALUES (?,?)
          SQL
    sql = DB[:conn].prepare(stm)
    sql.bind_param 1, self.name
    sql.bind_param 2, self.grade
    sql.execute

    @id = DB[:conn].execute("SELECT last_insert_rowid() from students")[0][0]
  end

  def self.create(name:, grade:)
    
    # attributes.each do |k,v| 
    #   self.send("#{k}=", v)
    # end

    # def initialize(nane, grade, id=nil)
    
    #   @id = id
    #   @name = name
    #   @grade = grade
    #   # binding.pry
    # end

    student = Student.new(name, grade)
    student.save
    student
  end
  
end
