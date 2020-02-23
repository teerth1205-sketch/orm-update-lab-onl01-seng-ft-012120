require_relative "../config/environment.rb"

class Student

attr_accessor :id, :name, :grade

def initialize(id = nil, name, grade)
@id =id
@name = name 
@grade = grade
end 

def self.create_table
  sql = "CREATE TABLE students (id INTEGER PRIMARY KEY, 
  name TEXT,
  grade INTEGER)"
  
  DB[:conn].execute(sql)
  
end 

def self.drop_table
  sql = "DROP TABLE students"
  
  DB[:conn].execute(sql)
end 

def save
  sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)
   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
end 

def self.create(name, grade)
  student = Student.new(name, grade)
  student.save 
  student 
end

def self.new_from_db(row)
   
   id = row[0]
   name = row[1]
   grade = row[2]
    Student.new(id,name, grade)
 end 
 
 def self.find_by_name(names)
   sql = "SELECT * FROM students WHERE name = ?"
   
  
  name = Student.new_from_db(DB[:conn].execute(sql, names))
   name 
end     
  
end
