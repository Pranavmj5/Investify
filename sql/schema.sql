-- Investify Database Schema
CREATE DATABASE IF NOT EXISTS investify;
USE investify;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('investor','founder','government','admin') NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Startup table
CREATE TABLE IF NOT EXISTS startup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    founder_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    domain VARCHAR(100),
    stage VARCHAR(50),
    tagline VARCHAR(200),
    description TEXT,
    funding_goal DECIMAL(15,2),
    funding_raised DECIMAL(15,2) DEFAULT 0,
    profile_views INT DEFAULT 0,
    equity_offered DECIMAL(5,2),
    min_ticket DECIMAL(15,2),
    valuation DECIMAL(15,2),
    risk_level VARCHAR(20),
    pitch_video VARCHAR(500),
    pitch_deck VARCHAR(500),
    logo VARCHAR(500),
    website VARCHAR(300),
    linkedin VARCHAR(300),
    hq_location VARCHAR(200),
    founded_year INT,
    status ENUM('draft','pending','approved','rejected') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (founder_id) REFERENCES users(id)
);

-- Documents table
CREATE TABLE IF NOT EXISTS documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startup_id INT NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    type VARCHAR(50),
    FOREIGN KEY (startup_id) REFERENCES startup(id)
);

-- Investment requests table
CREATE TABLE IF NOT EXISTS investment_request (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startup_id INT NOT NULL,
    investor_id INT NOT NULL,
    amount DECIMAL(15,2),
    message TEXT,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (startup_id) REFERENCES startup(id),
    FOREIGN KEY (investor_id) REFERENCES users(id)
);

-- Government schemes table
CREATE TABLE IF NOT EXISTS schemes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    target_sector VARCHAR(100) DEFAULT 'All Sectors',
    budget DECIMAL(15,2),
    description TEXT,
    status ENUM('active','draft','closed') DEFAULT 'draft',
    open_date DATE,
    close_date DATE,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Scheme applications table
CREATE TABLE IF NOT EXISTS scheme_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scheme_id INT NOT NULL,
    startup_id INT NOT NULL,
    status ENUM('pending','approved','under_review','disbursed','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scheme_id) REFERENCES schemes(id),
    FOREIGN KEY (startup_id) REFERENCES startup(id)
);

-- Government status table (legacy — startup-level approval)
CREATE TABLE IF NOT EXISTS government_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startup_id INT NOT NULL,
    approval_status ENUM('pending','approved','rejected') DEFAULT 'pending',
    scheme_name VARCHAR(200),
    grant_amount DECIMAL(15,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (startup_id) REFERENCES startup(id)
);