-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  provider VARCHAR(255) NOT NULL,
  type VARCHAR(10) NOT NULL CHECK (type IN ('FREE', 'PAID')),
  image_url TEXT,
  course_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add new columns to existing courses table if they don't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='courses' AND column_name='image_url') THEN
        ALTER TABLE courses ADD COLUMN image_url TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='courses' AND column_name='course_url') THEN
        ALTER TABLE courses ADD COLUMN course_url TEXT;
    END IF;
END $$;

-- Create admins table
CREATE TABLE IF NOT EXISTS admins (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default admin
INSERT INTO admins (email, password) 
VALUES ('tailorshreyash01@gmail.com', '15987450')
ON CONFLICT (email) DO NOTHING;

-- Insert some sample courses
INSERT INTO courses (title, description, provider, type, image_url, course_url) VALUES
('React Fundamentals', 'Learn the basics of React including components, state, and props. Perfect for beginners starting their React journey.', 'Meta', 'FREE', 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=500&h=300&fit=crop', 'https://react.dev/learn'),
('Advanced JavaScript', 'Deep dive into advanced JavaScript concepts including closures, async/await, and modern ES6+ features.', 'Google', 'PAID', 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=500&h=300&fit=crop', 'https://javascript.info'),
('Python for Data Science', 'Introduction to data science using Python, covering pandas, numpy, and basic machine learning concepts.', 'Microsoft', 'FREE', 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=500&h=300&fit=crop', 'https://python.org'),
('Node.js Backend Development', 'Build scalable backend applications with Node.js and Express framework.', 'Netflix', 'PAID', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=500&h=300&fit=crop', 'https://nodejs.org'),
('UI/UX Design Principles', 'Learn design principles and create beautiful user interfaces.', 'Adobe', 'FREE', 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500&h=300&fit=crop', 'https://adobe.com')
ON CONFLICT DO NOTHING;

-- Enable Row Level Security (RLS)
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public read access on courses" ON courses;
DROP POLICY IF EXISTS "Allow admin write access on courses" ON courses;
DROP POLICY IF EXISTS "Allow admin read access on admins" ON admins;

-- Create policies for courses (allow all operations for now)
CREATE POLICY "Enable read access for all users" ON courses FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON courses FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON courses FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON courses FOR DELETE USING (true);

-- Create policies for admins (allow all operations for now)
CREATE POLICY "Enable read access for all users on admins" ON admins FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users on admins" ON admins FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users on admins" ON admins FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users on admins" ON admins FOR DELETE USING (true);
