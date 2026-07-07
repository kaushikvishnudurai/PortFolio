-- Kaushik's portfolio schema + seed data.
-- Load with:  mysql -u root < db/schema.sql   (drops and recreates the database)
-- Your portfolio content lives HERE. Updating your portfolio = running an UPDATE. No redeploy.

DROP DATABASE IF EXISTS kaushik_portfolio;
CREATE DATABASE kaushik_portfolio CHARACTER SET utf8mb4;
USE kaushik_portfolio;

CREATE TABLE profile (
  id        INT PRIMARY KEY,
  name      VARCHAR(100) NOT NULL,
  role      VARCHAR(200) NOT NULL,
  location  VARCHAR(100),
  email     VARCHAR(150),
  github    VARCHAR(200),
  linkedin  VARCHAR(200),
  bio       TEXT
);

CREATE TABLE skills (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  name     VARCHAR(60) NOT NULL,
  category VARCHAR(30) NOT NULL       -- backend | frontend | tools | core
);

CREATE TABLE projects (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  period      VARCHAR(40),
  description TEXT NOT NULL,
  stack       VARCHAR(200) NOT NULL,
  lesson      VARCHAR(300)
);

CREATE TABLE journey (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  label      VARCHAR(40) NOT NULL,
  title      VARCHAR(120) NOT NULL,
  detail     TEXT,
  sort_order INT NOT NULL DEFAULT 0
);

CREATE TABLE guestbook (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(60) NOT NULL,
  message    VARCHAR(280) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE visits (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  path       VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---- Seed data (from Kaushik's resume; add a github URL when ready) ----

INSERT INTO profile VALUES (1,
  'Kaushik Vishnudurai',
  'Full Stack Developer Intern @ Zoho CRM',
  'Chennai, India',
  'kaushikvishnudurai@gmail.com',
  '',
  'https://www.linkedin.com/in/kaushikvishnudurai/',
  'Hi, I''m Kaushik.

I like building things and understanding how they actually work behind the screen. I enjoy frontend development too, but give me a backend problem, a database and enough time to debug it, and I''ll probably forget to check the clock.

I studied at Zoho Schools of Technology, where most of my learning came from building projects, getting stuck, asking questions and trying again.

Now I''m working as a Full Stack Developer Intern with the Zoho CRM team. My current work involves Java, Spring, Struts, JavaScript and MySQL.

I''m still learning, and there is a long list of things I don''t know yet. That''s probably the part I like most about being a developer.');

INSERT INTO skills (name, category) VALUES
  ('Core Java',                'backend'),
  ('Spring MVC',               'backend'),
  ('Struts',                   'backend'),
  ('JDBC',                     'backend'),
  ('MySQL',                    'backend'),
  ('Python',                   'backend'),
  ('OOP',                      'backend'),
  ('REST APIs',                'backend'),
  ('HTML5',                    'frontend'),
  ('CSS',                      'frontend'),
  ('JavaScript',               'frontend'),
  ('Efficient Prompting',      'ai-assisted development'),
  ('Context Engineering',      'ai-assisted development'),
  ('AI-Assisted Debugging',    'ai-assisted development'),
  ('AI-Assisted Code Review',  'ai-assisted development'),
  ('Agentic Coding Workflows', 'ai-assisted development'),
  ('Codex',                    'ai-assisted development'),
  ('Claude Code',              'ai-assisted development'),
  ('Git',                      'tools & technology'),
  ('Zoho CRM',                 'tools & technology'),
  ('Computer Networking',      'tools & technology'),
  ('Arduino / IoT',            'tools & technology'),
  ('Problem Solving',          'doesn''t fit in a tech stack'),
  ('Critical Thinking',        'doesn''t fit in a tech stack'),
  ('Adaptability',             'doesn''t fit in a tech stack'),
  ('Leadership',               'doesn''t fit in a tech stack');

INSERT INTO projects (name, period, description, stack, lesson) VALUES
  ('FoodBridge', 'Jun 2024 – Mar 2025',
   'A platform built to help manage food donations. I worked on donation management, donor tracking and reporting, with MySQL handling the data behind the application.',
   'Python, MySQL',
   'A database designed badly at the beginning will come back to haunt you later. I learned that one the practical way.'),
  ('Blue Hire', 'Jun 2023 – Mar 2024',
   'One of my earliest complete projects. I worked on the UI, the backend and the integration between them. Building the whole application helped me understand how frontend decisions affect backend logic, and how quickly a small feature can become complicated.',
   'Python',
   'This was the project where I stopped thinking of frontend and backend as completely separate worlds.'),
  ('This website', '2026',
   'Yes, the portfolio you''re currently reading is also a project. The content on this page is stored in MySQL and fetched through a Java backend. I wanted to understand what happens underneath frameworks, so I built the HTTP server without Spring or Tomcat. The terminal below talks to the same backend.',
   'Java, JDBC, MySQL, HTML, CSS, JavaScript',
   'I use frameworks at work. Here, I wanted to see how much I could build without one.');

INSERT INTO journey (label, title, detail, sort_order) VALUES
  ('2023',      'Class 10, CBSE',
   'Studied at Alwin International Public School, Padappai. At this point I was interested in technology, but I didn''t really know where it would take me.', 1),
  ('Sep 2023',  'Mind Martians — 6th place',
   'Took my science project to a competition at St. Joseph''s College of Engineering, competing alongside Class XI and XII students, and finished in 6th place. It was one of the first times I realised I genuinely enjoyed building something and explaining how it worked.', 2),
  ('2023–24',   'Blue Hire',
   'My first proper end-to-end project. I worked on the interfaces, backend logic and integration. The project wasn''t perfect, but it taught me what happens when separate pieces of an application finally have to work together.
And yes, they usually don''t work together on the first try.', 3),
  ('2024–25',   'Class 12, CBSE + FoodBridge',
   'Finished Class 12 while working on FoodBridge, a platform for managing food donations. This project made me think more seriously about database design and how software can be used for problems outside the usual student-project ideas.', 4),
  ('May 2025',  'Got curious about cybersecurity',
   'I joined what was supposed to be a two-hour cybersecurity webinar.
I stayed for five hours.
We covered phishing, threat intelligence and ethical hacking. I went in knowing very little and came out with far more questions than answers, which was a good thing.', 5),
  ('Jun 2025',  'Zoho Schools of Technology',
   'I joined Zoho Schools feeling nervous and not really knowing what to expect. There were no textbooks to memorise and no usual classroom routine. Most of the learning happened by solving problems, building projects, making mistakes and understanding why something failed.
That way of learning changed how I approach programming.', 6),
  ('Now',       'Full Stack Developer Intern — Zoho CRM',
   'I work with Java, Spring, Struts, JavaScript and MySQL, and I''m getting my first real experience with a large production codebase. There is a big difference between code that works on your laptop and code that has to work for real users. I''m learning that difference now.', 7);
