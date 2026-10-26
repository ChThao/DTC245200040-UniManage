CREATE TABLE IF NOT EXISTS classes (
 id INT AUTO_INCREMENT PRIMARY KEY, class_name VARCHAR(80) NOT NULL UNIQUE,
 major VARCHAR(120) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS students (
 student_code VARCHAR(20) PRIMARY KEY, full_name VARCHAR(120) NOT NULL,
 email VARCHAR(190) NOT NULL UNIQUE, phone VARCHAR(25), date_of_birth DATE,
 class_id INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_students_class FOREIGN KEY(class_id) REFERENCES classes(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS grades (
 id BIGINT AUTO_INCREMENT PRIMARY KEY, student_code VARCHAR(20) NOT NULL,
 subject_name VARCHAR(120) NOT NULL, score DECIMAL(4,2) NOT NULL, semester VARCHAR(40),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT chk_score CHECK(score >= 0 AND score <= 10),
 CONSTRAINT fk_grades_student FOREIGN KEY(student_code) REFERENCES students(student_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT IGNORE INTO classes(class_name,major) VALUES ('CNTT K23C','Công nghệ thông tin'),('HTTT K23A','Hệ thống thông tin'),('KTPM K22B','Kỹ thuật phần mềm');
INSERT IGNORE INTO students(student_code,full_name,email,phone,date_of_birth,class_id) VALUES
('SV2023001','Nguyễn Minh Anh','minhanh.demo@example.test','0900000001','2005-04-12',(SELECT id FROM classes WHERE class_name='CNTT K23C')),
('SV2023002','Trần Quốc Bảo','quocbao.demo@example.test','0900000002','2005-08-23',(SELECT id FROM classes WHERE class_name='CNTT K23C')),
('SV2023003','Lê Thu Hà','thuha.demo@example.test','0900000003','2005-01-09',(SELECT id FROM classes WHERE class_name='HTTT K23A'));
INSERT IGNORE INTO grades(student_code,subject_name,score,semester) VALUES ('SV2023001','Cơ sở dữ liệu',8.50,'HK1-2026'),('SV2023002','Lập trình',7.75,'HK1-2026'),('SV2023003','Mạng máy tính',9.00,'HK1-2026');
